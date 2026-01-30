import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_response.dart';
import 'package:flutter_vcf/models/pk/unloading_pk_model.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';
import 'add_unloading_pk.dart';
import 'input_unloading_pk.dart';

class UnloadingPKPage extends StatefulWidget {
  final String userId;
  final String token;

  const UnloadingPKPage({super.key, required this.userId, required this.token});

  @override
  State<UnloadingPKPage> createState() => _UnloadingPKPageState();
}

class _UnloadingPKPageState extends State<UnloadingPKPage> {
  int? selectedIndex;

  final apiService = ApiService(AppConfig.createDio());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  String normalizedStatus(String? registStatus, String? unloadingStatus) {
    final reg = (registStatus ?? "").toLowerCase();
    final unload = (unloadingStatus ?? "").toLowerCase();

    // HOLD tahap unloading (sudah selesai resampling + relab)
    if (reg == "unloading" && unload == "hold") return "hold_unloading";

    // HOLD tahap resampling (baru mulai resampling)
    if (reg == "qc_resampling" && unload == "hold") return "hold_resampling";

    if (reg == "qc_resampling") return "qc_resampling";
    if (reg == "wb_out") return "done";
    if (unload == "approved") return "done";

    return reg.isNotEmpty ? reg : unload;
  }

  String displayStatus(String status) {
    switch (status) {
      case "hold_unloading":
        return "HOLD (UNLOADING)";
      case "hold_resampling":
        return "HOLD (RESAMPLING)";
      case "qc_resampling":
        return "RESAMPLING";
      case "done":
        return "DONE";
      default:
        return status.toUpperCase();
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "hold_unloading":
        return Colors.orange;
      case "hold_resampling":
        return Colors.deepPurple;
      case "qc_resampling":
        return Colors.blue;
      case "done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "hold_unloading":
        return Icons.pause_circle_outline;
      case "hold_resampling":
        return Icons.repeat;
      case "qc_resampling":
        return Icons.refresh;
      case "done":
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _openAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddUnloadingPKPage(userId: widget.userId, token: widget.token),
      ),
    );

    if (result != null) setState(() {});
  }

  Future<void> _openEditPage(model.UnloadingPkModel data, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputUnloadingPKPage(model: data, token: widget.token),
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
        title: const Text("Dashboard Unloading PK"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<UnloadingPkResponse>(
        future: _getToken().then((t) => apiService.getUnloadingPk("Bearer $t")),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log("${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final trucks = snapshot.data?.data ?? [];

          final unloadingTrucks = trucks.where((e) {
            final status = normalizedStatus(e.registStatus, e.unloadingStatus);
            return status == "qc_resampling" ||
                status == "hold_unloading" ||
                status == "hold_resampling" ||
                status == "done";
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
                t.registStatus,
                t.unloadingStatus,
              );

              return GestureDetector(
                onTap: () {
                  if (status == "hold_unloading" ||
                      status == "hold_resampling" ||
                      status == "qc_resampling") {
                    _openEditPage(t, index);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Status ini tidak dapat dibuka."),
                      ),
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                          "Nomor Tiket Timbang : ${t.wbTicketNo ?? '-'}",
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
                              t.plateNumber ?? "-",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
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
