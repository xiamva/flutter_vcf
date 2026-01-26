import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataTrukCpoPage extends StatefulWidget {
  const DataTrukCpoPage({super.key});

  @override
  State<DataTrukCpoPage> createState() => _DataTrukCpoPageState();
}

class _DataTrukCpoPageState extends State<DataTrukCpoPage> {
  // ----- QC SAMPLE CPO -----
  int sampleMasuk = 0;
  int sampleBelum = 0;
  int sampleSudah = 0;
  int sampleKeluar = 0;

  // ----- QC LAB CPO -----
  int labMasuk = 0;
  int labBelum = 0;
  int labSudah = 0;
  int labKeluar = 0;

  // ----- UNLOADING CPO -----
  int unloadMasuk = 0;
  int unloadBelum = 0;
  int unloadSudah = 0;
  int unloadKeluar = 0;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
  final api = ApiService(AppConfig.createDio());
  final prefs = await SharedPreferences.getInstance();

  // Ambil token yang benar
  String? savedToken =
      prefs.getString("jwt_token") ?? prefs.getString("token");

  print("TOKEN TERBACA DI DATA_TRUK_CPO: $savedToken");

  if (savedToken == null || savedToken.isEmpty) {
    print("❌ TOKEN KOSONG — API TIDAK DIPANGGIL");
    return;
  }

  String token = savedToken.startsWith("Bearer ")
      ? savedToken
      : "Bearer $savedToken";

  final now = DateTime.now();
  String from = "${now.year}-01-01";
  String to = "${now.year}-12-31";

  try {
    // SAMPLE
    final sampleStats =
        await api.getQcSamplingStats(token, dateFrom: from, dateTo: to);

    setState(() {
      sampleMasuk =
          sampleStats.data?.statistics?.total_truk_masuk ?? 0;
      sampleBelum =
          sampleStats.data?.statistics?.truk_belum_ambil_sample ?? 0;
      sampleSudah =
          sampleStats.data?.statistics?.truk_sudah_ambil_sample ?? 0;
      sampleKeluar =
          sampleStats.data?.statistics?.total_truk_keluar ?? 0;
    });

    // LAB
    final labStats =
        await api.getQcLabCpoStatistics(token, dateFrom: from, dateTo: to);

    labMasuk = labStats.data?.statistics?.total_truk_masuk ?? 0;
    labBelum = labStats.data?.statistics?.truk_belum_cek_lab ?? 0;
    labSudah = labStats.data?.statistics?.truk_sudah_cek_lab ?? 0;
    labKeluar = labStats.data?.statistics?.total_truk_keluar ?? 0;

    // UNLOADING
    final unloadStats =
        await api.getUnloadingCpoStatistics(token, dateFrom: from, dateTo: to);

    unloadMasuk = unloadStats.data?.statistics?.total_truk_masuk ?? 0;
    unloadBelum = unloadStats.data?.statistics?.truk_belum_unloading ?? 0;
    unloadSudah = unloadStats.data?.statistics?.truk_sudah_unloading ?? 0;
    unloadKeluar = unloadStats.data?.statistics?.total_truk_keluar ?? 0;

    setState(() {});

  } catch (e) {
    print("Gagal load statistik CPO: $e");
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
          "DASHBOARD QC CPO",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadStatistics,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bigBox(
              icon: Icons.science,
              title: "QC Sample CPO",
              items: [
                ["Total Truk Masuk", "$sampleMasuk"],
                ["Truk Belum Ambil Sample", "$sampleBelum"],
                ["Truk Sudah Ambil Sample", "$sampleSudah"],
                ["Total Truk Keluar", "$sampleKeluar"],
              ],
              buttonText: "Input Data Sample",
            ),

            const SizedBox(height: 30),

            _bigBox(
              icon: Icons.biotech,
              title: "QC Lab CPO",
              items: [
                ["Total Truk Masuk", "$labMasuk"],
                ["Truk Belum Cek LAB", "$labBelum"],
                ["Truk Sudah Cek LAB", "$labSudah"],
                ["Total Truk Keluar", "$labKeluar"],
              ],
              buttonText: "Input Data QC Lab",
            ),

            const SizedBox(height: 30),

            _bigBox(
              icon: Icons.local_shipping,
              title: "Unloading CPO",
              items: [
                ["Total Truk Masuk", "$unloadMasuk"],
                ["Truk Belum Unloading", "$unloadBelum"],
                ["Truk Sudah Unloading", "$unloadSudah"],
                ["Total Truk Keluar", "$unloadKeluar"],
              ],
              buttonText: "Input Data Unloading",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------ BIG BOX ------------------
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          for (var item in items)
            _dashboardBox(title: item[0], value: item[1]),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                buttonText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ------------------ SMALL BOX ------------------
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
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
