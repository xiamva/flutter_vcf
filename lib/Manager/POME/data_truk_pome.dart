import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'tiket/sp_tiket_manager_pome.dart';
import 'tiket/lb_tiket_manager_pome.dart';
import 'tiket/un_tiket_manager_pome.dart';

class DataTrukPomePage extends StatefulWidget {
  const DataTrukPomePage({super.key});

  @override
  State<DataTrukPomePage> createState() => _DataTrukPomePageState();
}

class _DataTrukPomePageState extends State<DataTrukPomePage> {
  late ApiService api;

  bool isLoading = true;
  String? errorMsg;

  // QC SAMPLE
  int sampleMasuk = 0;
  int sampleBelum = 0;
  int sampleSudah = 0;
  int sampleKeluar = 0;

  // QC LAB
  int labMasuk = 0;
  int labBelum = 0;
  int labSudah = 0;
  int labKeluar = 0;

  // UNLOADING
  int unloadMasuk = 0;
  int unloadBelum = 0;
  int unloadSudah = 0;
  int unloadKeluar = 0;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    loadAll();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? prefs.getString("token");
  }

 Future<void> loadAll() async {
  try {
    final token = await _getToken();

    if (token == null) {
      setState(() => errorMsg = "Token tidak ditemukan");
      return;
    }

    String bearer = "Bearer $token";
    print("TOKEN POME: $bearer");

    final now = DateTime.now();
    String dateFrom = "${now.year}-01-01";
    String dateTo = "${now.year}-12-31";

    // ============ GET ALL DATA DARI API ============

    // QC SAMPLE
    final sample = await api.getQcSamplingPomeStats(
      bearer,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    final s = sample.data?.statistics;

    // QC LAB
    final lab = await api.getQcLabPomeStatistics(
      bearer,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    final l = lab.data?.statistics;

    // UNLOADING
    final unload = await api.getUnloadingPomeStatistics(
      bearer,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    final u = unload.data?.statistics;

    // ============ UPDATE UI ============

    setState(() {
      // QC SAMPLE
      sampleMasuk = s?.totalTrukMasuk ?? 0;
      sampleBelum = s?.trukBelumSample ?? 0;
      sampleSudah = s?.trukSudahSample ?? 0;
      sampleKeluar = s?.totalTrukKeluar ?? 0;

      // QC LAB
      labMasuk = l?.totalTrukMasuk ?? 0;
      labBelum = l?.belumCekLab ?? 0;
      labSudah = l?.sudahCekLab ?? 0;
      labKeluar = l?.totalTrukKeluar ?? 0;

      // UNLOADING
      unloadMasuk = u?.total_truk_masuk ?? 0;
      unloadBelum = u?.truk_belum_unloading ?? 0;
      unloadSudah = u?.truk_sudah_unloading ?? 0;
      unloadKeluar = u?.total_truk_keluar ?? 0;

      isLoading = false;
      errorMsg = null;
    });

  } catch (e) {
    setState(() {
      errorMsg = "Gagal memuat data: $e";
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
          "DASHBOARD QC POME",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadAll,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text(errorMsg!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _bigBox(
                        icon: Icons.science,
                        title: "QC Sample POME",
                        items: [
                          ["Total Truk Masuk", "$sampleMasuk"],
                          ["Truk Belum Ambil Sample", "$sampleBelum"],
                          ["Truk Sudah Ambil Sample", "$sampleSudah"],
                          ["Total Truk Keluar", "$sampleKeluar"],
                        ],
                        buttonText: "Input Data Sample",
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString("jwt_token") ?? prefs.getString("token") ?? "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SpTiketManagerPOMEPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      _bigBox(
                        icon: Icons.biotech,
                        title: "QC Lab POME",
                        items: [
                          ["Total Truk Masuk", "$labMasuk"],
                          ["Truk Belum Cek LAB", "$labBelum"],
                          ["Truk Sudah Cek LAB", "$labSudah"],
                          ["Total Truk Keluar", "$labKeluar"],
                        ],
                        buttonText: "Input Data QC Lab",
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString("jwt_token") ?? prefs.getString("token") ?? "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LbTiketManagerPOMEPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      _bigBox(
                        icon: Icons.local_shipping,
                        title: "Unloading POME",
                        items: [
                          ["Total Truk Masuk", "$unloadMasuk"],
                          ["Truk Belum Unloading", "$unloadBelum"],
                          ["Truk Sudah Unloading", "$unloadSudah"],
                          ["Total Truk Keluar", "$unloadKeluar"],
                        ],
                        buttonText: "Input Data Unloading",
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString("jwt_token") ?? prefs.getString("token") ?? "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UnTiketManagerPOMEPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  // =================== UI BOX COMPONENT ===================
  Widget _bigBox({
    required IconData icon,
    required String title,
    required List<List<String>> items,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
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
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardBox({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
