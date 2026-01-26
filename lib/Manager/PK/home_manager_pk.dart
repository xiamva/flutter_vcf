import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import '../../../login.dart';
import 'dart:async';

import '../CPO/home_manager.dart';
import '../POME/home_manager_pome.dart';
import 'data_truk_pk.dart';

class HomeManagerPk extends StatefulWidget {
  const HomeManagerPk({super.key});

  @override
  State<HomeManagerPk> createState() => _HomeManagerPkState();
}

class _HomeManagerPkState extends State<HomeManagerPk> {
  final PageController _controller = PageController(initialPage: 5000);
  final PageController infoController = PageController(initialPage: 0);

  int currentIndex = 0;
  int infoIndex = 0;
  Timer? autoSlideTimer;
  Timer? autoInfoTimer;
  bool showInputOptions = false;
  final String halamanAktif = "PK";

  // ================= STATISTIK PK =================
  int totalSampleKeluar = 0;
  int totalLabKeluar = 0;
  int totalUnloadingKeluar = 0;

  // ---------------- DATE FORMAT ----------------
  String getTanggalIndonesia() {
    final now = DateTime.now();
    const bulan = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return "${now.day} ${bulan[now.month - 1]} ${now.year}";
  }

  @override
  void initState() {
    super.initState();
    loadStatistics();

    autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_controller.hasClients) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    autoInfoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (infoController.hasClients) {
        final next = (infoIndex + 1) % 3;
        infoController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        if (mounted) setState(() => infoIndex = next);
      }
    });
  }

  @override
  void dispose() {
    autoSlideTimer?.cancel();
    autoInfoTimer?.cancel();
    _controller.dispose();
    infoController.dispose();
    super.dispose();
  }

  // ======================= LOAD PK STATISTICS ===========================
  Future<void> loadStatistics() async {
    final api = ApiService(AppConfig.createDio());
    final prefs = await SharedPreferences.getInstance();

    String? savedToken =
        prefs.getString("jwt_token") ?? prefs.getString("token");

    if (savedToken == null || savedToken.isEmpty) {
      print("TOKEN PK TIDAK ADA");
      return;
    }

    String token = savedToken.startsWith("Bearer ")
        ? savedToken
        : "Bearer $savedToken";

    final now = DateTime.now();
    String dateFrom = "${now.year}-01-01";
    String dateTo = "${now.year}-12-31";

    try {
      // SAMPLE PK
      final sampleRes = await api.getQcSamplingStatsPK(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      totalSampleKeluar =
          sampleRes.data?.statistics?.total_truk_keluar ?? 0;

      // LAB PK
      final labRes = await api.getQcLabPkStatistics(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      totalLabKeluar =
          labRes.data?.statistics?.total_truk_keluar ?? 0;

      // UNLOADING PK
      final unloadRes = await api.getUnloadingPkStatistics(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      totalUnloadingKeluar =
          unloadRes.data?.statistics?.totalTrukKeluar ?? 0;

      setState(() {});
    } catch (e) {
      print("ERROR LOAD STATISTICS PK: $e");
    }
  }

  void nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void prevPage() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.32;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      // ------------------ APPBAR ------------------
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: Row(
          children: [
            const Text(
              "Home VCF",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 6),

            PopupMenuButton<String>(
              color: Colors.blue.shade50,
              elevation: 4,
              offset: const Offset(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == halamanAktif) return;

                if (value == "CPO") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ManagerHomeSwipe()));
                } else if (value == "POME") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeManagerPome()));
                } else if (value == "PK") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeManagerPk()));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "CPO", child: Text("CPO")),
                PopupMenuItem(value: "POME", child: Text("POME")),
                PopupMenuItem(value: "PK", child: Text("PK")),
              ],
              child: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 34),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => loadStatistics(),
          ),
        ],
      ),

      // ------------------ DRAWER ------------------
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child:
                  Text("Menu VCF", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // ------------------ BODY ------------------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hai, Manager 👋",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text("Selamat datang di VEHICLE CONTROL SYSTEM",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),

              const SizedBox(height: 28),

              Center(
                child: Column(
                  children: [
                    const Text("QC Sample PK",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ------------------ CAROUSEL ------------------
              SizedBox(
                height: imageHeight + 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _controller,
                      onPageChanged: (index) =>
                          setState(() => currentIndex = index % 3),
                      itemBuilder: (context, index) {
                        final page = index % 3;

                        if (page == 0) {
                          return _imageCard("QC SAMPLE PK", "assets/pk.jpg", imageHeight);
                        } else if (page == 1) {
                          return _imageCard("QC SAMPLE CPO", "assets/cpo.jpg", imageHeight);
                        }
                        return _imageCard("QC SAMPLE POME", "assets/pome.jpg", imageHeight);
                      },
                    ),

                    Positioned(left: 0, child: _circleNavBtn(Icons.chevron_left_rounded, prevPage)),
                    Positioned(right: 0, child: _circleNavBtn(Icons.chevron_right_rounded, nextPage)),
                  ],
                ),
              ),

              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _dot(i)),
              ),

              const SizedBox(height: 40),

              // ------------------ INFO ------------------
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: infoController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) => setState(() => infoIndex = i),
                        children: [
                          _infoCard("Total Sample Truk Keluar", "$totalSampleKeluar"),
                          _infoCard("Total LAB Truk Keluar", "$totalLabKeluar"),
                          _infoCard("Total Unloading Truk Keluar", "$totalUnloadingKeluar"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(child: _infoCard("Tanggal Hari Ini", getTanggalIndonesia())),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _bottomButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ INFO CARD ------------------
  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      constraints: const BoxConstraints(minHeight: 65),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ------------------ BUTTONS ------------------
  Widget _bottomButtons() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => showInputOptions = !showInputOptions),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Input Data PK",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DataTrukPkPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Cek Total Truk",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOut,
            child: showInputOptions
                ? Column(
                    children: [
                      _optionItem("Sample", Icons.science),
                      const SizedBox(height: 10),
                      _optionItem("QC Lab", Icons.biotech),
                      const SizedBox(height: 10),
                      _optionItem("Unloading", Icons.local_shipping),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _optionItem(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ------------------ DOT ------------------
  Widget _dot(int i) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: currentIndex == i ? 14 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentIndex == i ? Colors.blue : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // ------------------ NAV BUTTON ------------------
  Widget _circleNavBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue, size: 32),
        onPressed: onTap,
      ),
    );
  }

  // ------------------ IMAGE CARD ------------------
  Widget _imageCard(String label, String path, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Image.asset(path, fit: BoxFit.cover),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
