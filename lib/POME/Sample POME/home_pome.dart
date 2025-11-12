import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/response/qc_sampling_pome_statistics_response.dart';
import 'sample_qc_pome.dart';
import '../../login.dart';

class HomePOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const HomePOMEPage({super.key, required this.userId, required this.token});

  @override
  State<HomePOMEPage> createState() => _HomePOMEPageState();
}

class _HomePOMEPageState extends State<HomePOMEPage> {
  bool isLoading = true;
  String? errorMessage;

  int totalMasuk = 0;
  int belumSample = 0;
  int sudahSample = 0;
  int totalKeluar = 0;
  String? lastUpdate;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(Dio());
    fetchStats();
  }

  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  Future<void> fetchStats() async {
    try {
      final token = await _token();
      final res = await api.getQcSamplingPomeStats(
        "Bearer $token",
        dateFrom: "2025-01-01",
        dateTo: "2025-12-31",
      );

      final stats = res.data?.statistics;
      final period = res.data?.period;

      setState(() {
        totalMasuk = stats?.totalTrukMasuk ?? 0;
        belumSample = stats?.trukBelumSample ?? 0;
        sudahSample = stats?.trukSudahSample ?? 0;
        totalKeluar = stats?.totalTrukKeluar ?? 0;
        lastUpdate = period?.to ?? "-";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
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
              onChanged: (String? value) {
                if (value == "POME") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SampleQCPOMEPage(
                        userId: widget.userId,
                        token: widget.token,
                      ),
                    ),
                  );
                }
              },
              items: const [
                DropdownMenuItem(
                  enabled: false,
                  child: Row(
                    children: [
                      Text("Sample QC", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
                DropdownMenuItem(value: "POME", child: Text("POME")),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchStats),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Menu VCF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
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
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hai, QC Sample 👋", style: Theme.of(context).textTheme.titleMedium),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("Last Update : ${lastUpdate ?? '-'}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
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
                                Text("QC Sample POME",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _row("Total Truk Masuk", "$totalMasuk"),
                            _row("Belum Sample", "$belumSample"),
                            _row("Sudah Sample", "$sudahSample"),
                            _row("Total Truk Keluar", "$totalKeluar"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

Widget _row(String title, String value) {
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
