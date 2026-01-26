import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';

class DataTrukPkPage extends StatefulWidget {
  const DataTrukPkPage({super.key});

  @override
  State<DataTrukPkPage> createState() => _DataTrukPkPageState();
}

class _DataTrukPkPageState extends State<DataTrukPkPage> {
  final api = ApiService(AppConfig.createDio());

  bool isLoading = true;
  String? errorMessage;

  // SAMPLE PK
  int totalMasukSample = 0;
  int belumSample = 0;
  int sudahSample = 0;
  int totalKeluarSample = 0;

  // LAB PK
  int totalMasukLab = 0;
  int belumLab = 0;
  int sudahLab = 0;
  int totalKeluarLab = 0;

  // UNLOADING PK
  int totalMasukUnload = 0;
  int belumUnload = 0;
  int sudahUnload = 0;
  int totalKeluarUnload = 0;

  @override
  void initState() {
    super.initState();
    loadAllStatistics();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  Future<void> loadAllStatistics() async {
    try {
      final token = await _getToken();
      if (token == null) throw "Token tidak ditemukan";

      final auth = "Bearer $token";

      final now = DateTime.now();
      final from = "${now.year}-01-01";
      final to = "${now.year}-12-31";

      // ====================== SAMPLE PK ======================
      final sampleRes = await api.getQcSamplingStatsPK(
        auth,
        dateFrom: from,
        dateTo: to,
      );

      final sample = sampleRes.data?.statistics;

      // ====================== LAB PK ======================
      final labRes = await api.getQcLabPkStatistics(
        auth,
        dateFrom: from,
        dateTo: to,
      );

      final lab = labRes.data?.statistics;

      // ====================== UNLOADING PK ======================
      final unloadRes = await api.getUnloadingPkStatistics(
        auth,
        dateFrom: from,
        dateTo: to,
      );

      final unload = unloadRes.data?.statistics;

      setState(() {
        // SAMPLE PK
        totalMasukSample = sample?.total_truk_masuk ?? 0;
        belumSample = sample?.truk_belum_ambil_sample ?? 0;
        sudahSample = sample?.truk_sudah_ambil_sample ?? 0;
        totalKeluarSample = sample?.total_truk_keluar ?? 0;

        // LAB PK
        totalMasukLab = lab?.total_truk_masuk ?? 0;
        belumLab = lab?.truk_belum_cek_lab ?? 0;
        sudahLab = lab?.truk_sudah_cek_lab ?? 0;
        totalKeluarLab = lab?.total_truk_keluar ?? 0;

        // UNLOADING PK
        totalMasukUnload = unload?.totalTrukMasuk ?? 0;
        belumUnload = unload?.trukBelumUnloading ?? 0;
        sudahUnload = unload?.trukSudahUnloading ?? 0;
        totalKeluarUnload = unload?.totalTrukKeluar ?? 0;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Gagal memuat data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DASHBOARD QC PK",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadAllStatistics,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // QC SAMPLE PK
                      _bigBox(
                        icon: Icons.science,
                        title: "QC Sample PK",
                        items: [
                          ["Total Truk Masuk", "$totalMasukSample"],
                          ["Truk Belum Ambil Sample", "$belumSample"],
                          ["Truk Sudah Ambil Sample", "$sudahSample"],
                          ["Total Truk Keluar", "$totalKeluarSample"],
                        ],
                        buttonText: "Input Data Sample PK",
                      ),

                      const SizedBox(height: 30),

                      // QC LAB PK
                      _bigBox(
                        icon: Icons.biotech,
                        title: "QC Lab PK",
                        items: [
                          ["Total Truk Masuk", "$totalMasukLab"],
                          ["Truk Belum Cek LAB", "$belumLab"],
                          ["Truk Sudah Cek LAB", "$sudahLab"],
                          ["Total Truk Keluar", "$totalKeluarLab"],
                        ],
                        buttonText: "Input Data QC Lab PK",
                      ),

                      const SizedBox(height: 30),

                      // UNLOADING PK
                      _bigBox(
                        icon: Icons.local_shipping,
                        title: "Unloading PK",
                        items: [
                          ["Total Truk Masuk", "$totalMasukUnload"],
                          ["Truk Belum Unloading", "$belumUnload"],
                          ["Truk Sudah Unloading", "$sudahUnload"],
                          ["Total Truk Keluar", "$totalKeluarUnload"],
                        ],
                        buttonText: "Input Data Unloading PK",
                      ),
                    ],
                  ),
                ),
    );
  }

  // UI Components
  Widget _bigBox({
    required IconData icon,
    required String title,
    required List<List<String>> items,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 26, color: Colors.black),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),

          const SizedBox(height: 16),

          for (var item in items) _dashboardBox(title: item[0], value: item[1]),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {},
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardBox({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
