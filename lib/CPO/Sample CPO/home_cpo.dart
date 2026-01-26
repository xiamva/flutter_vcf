import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import '../../login.dart';
import 'sample_qc.dart';

class HomeCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const HomeCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<HomeCPOPage> createState() => _HomeCPOPageState();
}

class _HomeCPOPageState extends State<HomeCPOPage> {
  bool isLoading = true;
  String? errorMessage;

  int totalMasuk = 0;
  int belumSample = 0;
  int sudahSample = 0;
  int totalKeluar = 0;
  String? lastUpdate = "-";

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    fetchCPOStatistics();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  Future<void> fetchCPOStatistics() async {
    try {
      final token = await _getToken();

      final res = await api.getQcSamplingStats(
        "Bearer $token",
        dateFrom: "2025-01-01",
        dateTo: "2025-12-31",
      );

      final stats = res.data?.statistics;
      final period = res.data?.period;

      setState(() {
        totalMasuk = stats?.total_truk_masuk ?? 0;
        belumSample = stats?.truk_belum_ambil_sample ?? 0;
        sudahSample = stats?.truk_sudah_ambil_sample ?? 0;
        totalKeluar = stats?.total_truk_keluar ?? 0;
        lastUpdate = DateTime.now().toString();
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        errorMessage = "Gagal mengambil data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Home VCF", style: TextStyle(color: Colors.white)),
            const SizedBox(width: 5),
            DropdownButton<String>(
              dropdownColor: Colors.blue[100],
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              value: null,
              hint: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue == "CPO") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SampleQCPage(
                        userId: widget.userId,
                        token: widget.token,
                      ),
                    ),
                  );
                }
              },
              items: const [
                DropdownMenuItem<String>(
                  enabled: false,
                  child: Row(
                    children: [
                      Text("Sample QC", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(value: "CPO", child: Text("CPO")),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchCPOStatistics,
          )
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu VCF",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hai, QC Sample 👋",
                          style: Theme.of(context).textTheme.titleMedium),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("Last Update : $lastUpdate",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      const SizedBox(height: 20),

                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.black54),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.science, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text("QC Sample CPO",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildInfoRow("Total Truk Masuk", "$totalMasuk"),
                              _buildInfoRow("Truk Belum Ambil Sample", "$belumSample"),
                              _buildInfoRow("Truk Sudah Ambil Sample", "$sudahSample"),
                              _buildInfoRow("Total Truk Keluar", "$totalKeluar"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  static Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(title),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
