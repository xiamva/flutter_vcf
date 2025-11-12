import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/response/qc_sampling_pome_vehicles_response.dart';
import 'add_sample_qc_pome.dart';

class SampleQCPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const SampleQCPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<SampleQCPOMEPage> createState() => _SampleQCPOMEPageState();
}

class _SampleQCPOMEPageState extends State<SampleQCPOMEPage> {
  List<Map<String, dynamic>> tickets = [];
  bool isLoading = false;

  static const String _kCacheKey = 'cached_tickets_sampling_pome';

  late ApiService api;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    api = ApiService(dio);

    loadCachedTickets().then((_) => fetchTickets());
  }

  Future<void> loadCachedTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kCacheKey);

      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> data = jsonDecode(raw);
        setState(() {
          tickets = data.whereType<Map>()
                        .map((e) => Map<String, dynamic>.from(e))
                        .toList();
        });
      }
    } catch (_) {}
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
      final res = await api.getQcSamplingPomeVehicles("Bearer $token");

      final list = res.data
          ?.where((e) => e.hasSamplingData == true)
          .map(
            (e) => {
              "registration_id": e.registrationId ?? "-",
              "tiket_no": e.wbTicketNo ?? "-",
              "plat": e.plateNumber ?? "-",
              "status": "done"
            },
          )
          .toList() ?? [];

      setState(() {
        tickets = list.cast<Map<String, dynamic>>();
        isLoading = false;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCacheKey);
      await saveTicketsCache();

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetch: $e")));

      await loadCachedTickets();
    }
  }

  Color _statusColor(String s) => Colors.green;
  IconData _statusIcon(String s) => Icons.check_circle_outline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Sampling POME"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchTickets)
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada tiket yang sudah di-sample.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTickets,
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (_, i) {
                      final item = tickets[i];
                      return Card(
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
                                "Nomor Tiket Timbang : ${item["tiket_no"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item["plat"] ?? "-", style: const TextStyle(fontSize: 15)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.15),
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                        SizedBox(width: 4),
                                        Text("DONE",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
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
              builder: (_) => AddSampleQCPOMEPage(
                userId: widget.userId,
                token: widget.token,
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
