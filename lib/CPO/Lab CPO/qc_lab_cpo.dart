import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';

import 'package:flutter_vcf/models/qc_lab_cpo_vehicle.dart';
import 'add_lab_cpo.dart';
import 'input_lab_cpo.dart';

class QCLabCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const QCLabCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<QCLabCPOPage> createState() => _QCLabCPOPageState();
}

class _QCLabCPOPageState extends State<QCLabCPOPage> {
  List<QcLabCpoVehicle> tickets = [];
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
    final res = await api.getQcLabCpoVehicles("Bearer $token");

    final vehicles = (res.data ?? []).where((v) {
      final regist = (v.regist_status ?? "").toLowerCase();
      final labStatus = (v.lab_status ?? "").toLowerCase();

      // tampilkan jika hasil lab sudah ada
      final isLabProcessed = ["hold", "approved", "rejected"].contains(labStatus);

      // regist_status bisa 'qc_lab', 'qc_lab_hold', atau 'unloading'
      final isValidRegist = regist.startsWith("qc_lab") || regist == "unloading";

      return isValidRegist && isLabProcessed;
    }).toList();

    setState(() {
      tickets = vehicles;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}



  Color _statusColor(String s) {
    switch (s) {
      case "approved":
        return Colors.green;
      case "hold":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case "approved":
        return Icons.check_circle_outline;
      case "hold":
        return Icons.pause_circle_outline;
      case "rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_bottom;
    }
  }

  Future<void> _openAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddLabCPOPage(userId: widget.userId, token: widget.token),
      ),
    );

    if (result != null) fetchTickets();
  }

  Future<void> _openEditPage(QcLabCpoVehicle v) async {
    // sesuai pola unloading langsung kirim model
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputLabCPOPage(
          token: widget.token,
          model: v,
        ),
      ),
    );

    if (result != null) fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard QC Lab CPO"),
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
                    "Belum ada tiket QC Lab CPO",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (_, i) {
                    final t = tickets[i];
                    final status =
                        (t.lab_status ?? "").toLowerCase();

                    return GestureDetector(
                      onTap: () {
                        if (status == "hold") _openEditPage(t);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text("Tiket: ${t.wb_ticket_no ?? '-'}"),
                          subtitle: Text("Plat: ${t.plate_number ?? '-'}"),
                          trailing: Chip(
                            backgroundColor:
                                _statusColor(status).withOpacity(0.15),
                            side: BorderSide(color: _statusColor(status)),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_statusIcon(status),
                                    color: _statusColor(status), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                      color: _statusColor(status),
                                      fontWeight: FontWeight.bold),
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
