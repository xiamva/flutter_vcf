import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_response.dart';
import 'package:flutter_vcf/models/unloading_cpo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_unloading_cpo.dart';
import 'input_unloading_cpo.dart';

class UnloadingCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const UnloadingCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<UnloadingCPOPage> createState() => _UnloadingCPOPageState();
}

class _UnloadingCPOPageState extends State<UnloadingCPOPage> {
  int? selectedIndex;

  final apiService = ApiService(
    Dio(BaseOptions(contentType: "application/json")),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  // ===========================
  // STATUS NORMALIZER
  // ===========================
  String normalizedStatus(String? s) {
    final v = (s ?? "").toLowerCase().trim();
    if (v == "hold" || v == "unloading_hold") return "unloading_hold";
    if (v == "approved" || v == "wb_out") return "wb_out";
    return v;
  }

  // ===========================
  // STATUS UI MAPPER
  // ===========================
  String displayStatus(String status) {
    switch (status) {
      case "unloading_hold":
        return "HOLD";
      case "wb_out":
        return "APPROVED";
      case "rejected":
        return "REJECTED";
      default:
        return status.toUpperCase();
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "unloading_hold":
        return Colors.orange;
      case "wb_out":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "unloading_hold":
        return Icons.pause_circle_outline;
      case "wb_out":
        return Icons.check_circle_outline;
      case "rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // OPEN ADD PAGE
  Future<void> _openAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddUnloadingCPOPage(
          userId: widget.userId,
          token: widget.token,
        ),
      ),
    );
    if (result != null) setState(() {});
  }

  // OPEN EDIT PAGE (ONLY HOLD)
  Future<void> _openEditPage(UnloadingCpoModel model, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputUnloadingCPOPage(
          model: model,
          token: widget.token,
        ),
      ),
    );

    if (result != null) setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Unloading CPO"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),

      body: FutureBuilder<UnloadingCPOResponse>(
        future: _getToken().then((t) => apiService.getPosts("Bearer $t")),
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            log("${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final trucks = snapshot.data?.data ?? [];

          // ==========================================
          // FILTER MENGGUNAKAN NORMALIZED STATUS
          // ==========================================
          final unloadingTrucks = trucks.where((e) {
            final normalized = normalizedStatus(
              (e.unloading_status ?? "").isNotEmpty
                  ? e.unloading_status
                  : e.regist_status,
            );

            return normalized == "unloading_hold" || normalized == "wb_out";
          }).toList();

          if (unloadingTrucks.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada tiket kendaraan.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: unloadingTrucks.length,
            itemBuilder: (_, index) {
              final t = unloadingTrucks[index];

              final status = normalizedStatus(
                (t.unloading_status ?? "").isNotEmpty
                    ? t.unloading_status
                    : t.regist_status,
              );

              return GestureDetector(
                onTap: () {
                  if (status == "unloading_hold") {
                    _openEditPage(t, index);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Status selesai — tidak dapat dibuka"),
                      ),
                    );
                  }
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nomor Tiket Timbang : ${t.wb_ticket_no ?? '-'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.plate_number ?? "-",
                              style: const TextStyle(fontSize: 15),
                            ),

                            // STATUS BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: statusColor(status).withOpacity(0.15),
                                border:
                                    Border.all(color: statusColor(status)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    statusIcon(status),
                                    size: 16,
                                    color: statusColor(status),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    displayStatus(status),
                                    style: TextStyle(
                                      color: statusColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _openAddPage,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
