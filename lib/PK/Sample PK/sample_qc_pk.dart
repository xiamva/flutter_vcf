import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pk/response/qc_sampling_pk_vehicles_response.dart';
import 'add_sample_qc_pk.dart';
import 'add_pk_data.dart';

class SampleQCPKPage extends StatefulWidget {
  final String userId;
  final String token;

  const SampleQCPKPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<SampleQCPKPage> createState() => _SampleQCPKPageState();
}

class _SampleQCPKPageState extends State<SampleQCPKPage> {
  List<Map<String, dynamic>> tickets = [];
  bool isLoading = false;

  static const String _kCacheKey = 'cached_tickets_sampling_pk';

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    loadCachedTickets().then((_) => fetchTickets());
  }

  Future<void> loadCachedTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kCacheKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> data = jsonDecode(raw);
        setState(() {
          tickets = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } catch (_) {
    }
  }

  Future<void> saveTicketsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCacheKey, jsonEncode(tickets));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? widget.token;
  }

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);

    try {
      final token = await getToken();
      final res = await api.getQcSamplingPkVehicles("Bearer $token");

      final List<QcSamplingPkVehicle> vehicles = res.data ?? <QcSamplingPkVehicle>[];

      final list = vehicles
          .where((e) => e.has_sampling_data == true)
          .map((e) {
        final bool resampling = e.is_resampling == true;
        final String status = resampling ? "RE-SAMPLING" : "DONE";

        return {
          "registration_id": e.registration_id,
          "tiket_no": e.wb_ticket_no,
          "plat": e.plate_number,
          "vendor_code": e.vendor_code,
          "vendor_name": e.vendor_name,
          "commodity_code": e.commodity_code,
          "commodity_name": e.commodity_name,
          "is_resampling": resampling,
          "status": status,
        };
      }).toList();

      setState(() {
        tickets = list.cast<Map<String, dynamic>>();
        isLoading = false;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCacheKey);
      await saveTicketsCache();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetch: $e")),
      );
      await loadCachedTickets();
    }
  }

  Color _getStatusColor(Map item) {
    final status = item["status"] as String? ?? "";
    if (status == "RE-SAMPLING") {
      return Colors.red;
    }
    return Colors.green;
  }

  Color _getStatusBg(Map item) {
    return _getStatusColor(item).withOpacity(0.15);
  }

  IconData _getStatusIcon(Map item) {
    final status = item["status"] as String? ?? "";
    if (status == "RE-SAMPLING") {
      return Icons.warning_amber_rounded;
    }
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Sampling PK"),
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
                    "Belum ada kendaraan PK yang sudah sample.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTickets,
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (_, i) {
                      final item = tickets[i];

                      return InkWell(
                        onTap: () {
                          // Hanya tiket yang statusnya RE-SAMPLING yang boleh dibuka untuk re-sample
                          if (item["status"] == "RE-SAMPLING") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddPKDataPage(
                                  userId: widget.userId,
                                  token: widget.token,
                                  registrationId: item["registration_id"],
                                  platKendaraan: item["plat"],
                                  tiketNo: item["tiket_no"],
                                  vendorCode: item["vendor_code"] ?? "-",
                                  vendorName: item["vendor_name"] ?? "-",
                                  commodityCode: item["commodity_code"] ?? "-",
                                  commodityName: item["commodity_name"] ?? "-",
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                fetchTickets();
                              }
                            });
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
                                  "Nomor Tiket Timbang : ${item["tiket_no"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["plat"] ?? "-",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusBg(item),
                                        border: Border.all(
                                          color: _getStatusColor(item),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _getStatusIcon(item),
                                            size: 16,
                                            color: _getStatusColor(item),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item["status"],
                                            style: TextStyle(
                                              color: _getStatusColor(item),
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
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSampleQCPKPage(
                userId: widget.userId,
                token: widget.token,
              ),
            ),
          ).then((value) {
            if (value == true) {
              fetchTickets();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
