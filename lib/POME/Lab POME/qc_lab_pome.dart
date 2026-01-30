import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';

import 'package:flutter_vcf/models/pome/qc_lab_pome_vehicle.dart';
import 'add_lab_pome.dart';
import 'input_lab_pome.dart';

class QCLabPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const QCLabPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<QCLabPOMEPage> createState() => _QCLabPOMEPageState();
}

class _QCLabPOMEPageState extends State<QCLabPOMEPage> {
  List<QcLabPomeVehicle> tickets = [];
  bool isLoading = false;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    fetchTickets();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? widget.token;
  }

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);

    try {
      final token = await getToken();
      final res = await api.getQcLabPomeVehicles("Bearer $token");

      final vehicles = (res.data ?? [])
    .where((v) {
      final s = v.registStatus?.toLowerCase() ?? "";
      final lab = v.labStatus?.toLowerCase();

      // rule:
      // show only if already processed OR in HOLD
      return s == "qc_lab_hold" ||
             s == "unloading" ||
             s == "qc_lab_rejected" ||
             (s == "qc_lab" && lab != null); 
    })
    .toList();

      setState(() {
        tickets = vehicles;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"))
      );
    }
  }

  // Label berdasarkan lab_status
  String statusLabel(String lab) {
    switch (lab) {
      case "approved": return "APPROVED";
      case "hold": return "HOLD";
      case "rejected": return "REJECTED";
      default: return "PENDING";
    }
  }

  Color statusColor(String lab) {
    switch (lab) {
      case "approved": return Colors.green;
      case "hold": return Colors.orange;
      case "rejected": return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData statusIcon(String lab) {
    switch (lab) {
      case "approved": return Icons.check_circle_outline;
      case "hold": return Icons.pause_circle_outline;
      case "rejected": return Icons.cancel_outlined;
      default: return Icons.hourglass_bottom;
    }
  }

  Future<void> _openAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>
          AddLabPOMEPage(userId: widget.userId, token: widget.token),
      ),
    );

    if (result != null) fetchTickets();
  }

  Future<void> _openEditPage(QcLabPomeVehicle v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>
          InputLabPOMEPage(token: widget.token, model: v),
      ),
    );

    if (result != null) fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard QC Lab POME"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTickets,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada tiket QC Lab POME",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (_, i) {
                    final t = tickets[i];

                    final lab = (t.labStatus ?? "").toLowerCase();

                    return GestureDetector(
                      onTap: () {
                        if (lab == "hold") _openEditPage(t);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text("Tiket: ${t.wbTicketNo ?? '-'}"),
                          subtitle: Text("Plat: ${t.plateNumber ?? '-'}"),
                          trailing: Chip(
                            backgroundColor: statusColor(lab).withOpacity(0.15),
                            side: BorderSide(color: statusColor(lab)),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon(lab),
                                    color: statusColor(lab), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  statusLabel(lab),
                                  style: TextStyle(
                                    color: statusColor(lab),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _openAddPage,
      ),
    );
  }
}
