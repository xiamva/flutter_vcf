import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_response.dart';
import 'package:flutter_vcf/models/pome/unloading_pome_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_unloading_pome.dart';
import 'input_unloading_pome.dart';

class UnloadingPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const UnloadingPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<UnloadingPOMEPage> createState() => _UnloadingPOMEPageState();
}

class _UnloadingPOMEPageState extends State<UnloadingPOMEPage> {
  int? selectedIndex;

  final apiService = ApiService(
    Dio(BaseOptions(contentType: "application/json")),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  // ======== UI STATUS MAPPER =========

  String displayStatus(String status) {
    switch (status) {
      case "wb_out":
        return "APPROVED";
      case "unloading_hold":
        return "HOLD";
      case "rejected":
        return "REJECTED";
      default:
        return status.toUpperCase();
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "wb_out":
        return Colors.green;
      case "unloading_hold":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "wb_out":
        return Icons.check_circle_outline;
      case "unloading_hold":
        return Icons.pause_circle_outline;
      case "rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // Open Add page (choose vehicle)
  Future<void> _openAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddUnloadingPOMEPage(
          userId: widget.userId,
          token: widget.token,
        ),
      ),
    );
    if (result != null) setState(() {});
  }

  // Open Input page (only when HOLD)
  Future<void> _openEditPage(UnloadingPomeModel model, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputUnloadingPOMEPage(
          model: model,
          token: widget.token,
        ),
      ),
    );

    if (result != null) {
      setState(() => selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Unloading POME"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),

      body: FutureBuilder<UnloadingPOMEResponse>(
        future: _getToken().then((t) => apiService.getUnloadingPomeData("Bearer $t")),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            log("${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final trucks = snapshot.data?.data ?? [];

          // Only show HOLD & FINISHED (wb_out)
          final unloadingTrucks = trucks.where((e) {
            final s = e.regist_status?.toLowerCase() ?? "";
            return s == "wb_out" || s == "unloading_hold";
          }).toList();

          // Empty view
          if (unloadingTrucks.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada tiket kendaraan POME.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: unloadingTrucks.length,
            itemBuilder: (_, index) {
              final t = unloadingTrucks[index];

              final status = (t.unloading_status?.toLowerCase() ?? "").isEmpty
                  ? (t.regist_status?.toLowerCase() ?? "")
                  : t.unloading_status!.toLowerCase();

              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  if (status == "unloading_hold") {
                    setState(() => selectedIndex = index);
                    _openEditPage(t, index);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Status selesai — tidak dapat dibuka")),
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: statusColor(status).withOpacity(0.15),
                                border: Border.all(color: statusColor(status)),
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
                            )
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
