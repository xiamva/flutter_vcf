import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pome/response/qc_lab_pome_statistics_response.dart';
import 'qc_lab_pome.dart';
import '../../login.dart';

class HomeLabPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const HomeLabPOMEPage({super.key, required this.userId, required this.token});

  @override
  State<HomeLabPOMEPage> createState() => _HomeLabPOMEPageState();
}

class _HomeLabPOMEPageState extends State<HomeLabPOMEPage> {
  bool isLoading = true;
  String? errorMessage;

  int totalMasuk = 0;
  int belumCekLab = 0;
  int sudahCekLab = 0;
  int totalKeluar = 0;
  String? lastUpdate;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    fetchStats();
  }

  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  Future<void> fetchStats() async {
    setState(() => isLoading = true);

    try {
      final token = await _token();
      final res = await api.getQcLabPomeStatistics("Bearer $token");

      final stats = res.data?.statistics;
      final period = res.data?.period;

      setState(() {
        totalMasuk = stats?.totalTrukMasuk ?? 0;
        belumCekLab = stats?.belumCekLab ?? 0;
        sudahCekLab = stats?.sudahCekLab ?? 0;
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
              onChanged: (value) {
                if (value == "POME") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QCLabPOMEPage(
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
                      Text("Quality Check", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
                DropdownMenuItem(value: "POME", child: Text("POME")),
              ],
            )
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchStats),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                ),
              ),
              child: const Center(
                child: Text(
                  "Menu VCF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hai, QC Lab POME 👋", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Last Update : ${lastUpdate ?? '-'}",
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
                                  Text(
                                    "QC Lab POME",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildInfoRow("Total Truk Masuk", totalMasuk.toString()),
                              _buildInfoRow("Belum Cek Lab", belumCekLab.toString()),
                              _buildInfoRow("Sudah Cek Lab", sudahCekLab.toString()),
                              _buildInfoRow("Total Truk Keluar", totalKeluar.toString()),
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

Widget _buildInfoRow(String title, String value) {
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
