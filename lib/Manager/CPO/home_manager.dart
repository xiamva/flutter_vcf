import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vcf/Manager/CPO/tiket/lb_tiket_manager_cpo.dart';
import 'package:flutter_vcf/Manager/CPO/tiket/sp_tiket_manager_cpo.dart';
import 'package:flutter_vcf/Manager/CPO/tiket/un_tiket_manager_cpo.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../login.dart';
import '../PK/home_manager_pk.dart';
import '../POME/home_manager_pome.dart';
import 'data_truk_cpo.dart';

class ManagerHomeSwipe extends StatefulWidget {
  const ManagerHomeSwipe({super.key});

  @override
  State<ManagerHomeSwipe> createState() => _ManagerHomeSwipeState();
}

class _ManagerHomeSwipeState extends State<ManagerHomeSwipe> {
  final PageController _controller = PageController(initialPage: 5000);
  final PageController infoController = PageController(initialPage: 0);

  int currentIndex = 0;
  int infoIndex = 0;
  Timer? autoSlideTimer;
  Timer? autoInfoTimer;
  bool showInputOptions = false;
  final String halamanAktif = "CPO";

  int totalSampleKeluar = 0;
  int totalLabKeluar = 0;
  int totalUnloadingKeluar = 0;

  // Manager check statistics for carousel
  int samplingPendingChecks = 0;
  int labPendingChecks = 0;
  int unloadingPendingChecks = 0;

  int samplingApprovedChecks = 0;
  int labApprovedChecks = 0;
  int unloadingApprovedChecks = 0;

  // ---------------- DATE FORMAT (INDONESIA) ----------------
  String getTanggalIndonesia() {
    final now = DateTime.now();
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return "${now.day} ${bulan[now.month - 1]} ${now.year}";
  }

  // ---------------- GET IMAGE URL FROM BACKEND ----------------
  String getImageUrl(String imagePath) {
    // Remove /api/ from base URL to get the base server URL
    String baseUrl = AppConfig.apiBaseUrl.replaceAll('/api/', '');
    // Remove trailing slash if present
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    // Construct full URL: baseUrl/imagePath
    // imagePath should be like: vcs/carousel/cpo_sampling.jpg
    if (imagePath.startsWith('/')) {
      return '$baseUrl$imagePath';
    }
    return '$baseUrl/$imagePath';
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

  // ======================= LOAD STATISTICS API ===========================
  Future<void> loadStatistics() async {
    final api = ApiService(AppConfig.createDio());

    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken =
          prefs.getString("jwt_token") ?? prefs.getString("token");

      if (savedToken == null) {
        return;
      }

      // Normalize token: strip Bearer prefix if present, then add it
      String token = savedToken.startsWith("Bearer ")
          ? savedToken
          : "Bearer $savedToken";

      final now = DateTime.now();
      String dateFrom = "${now.year}-01-01";
      String dateTo = "${now.year}-12-31";

      // Load operator statistics
      final sampleStats = await api.getQcSamplingStats(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      final labStats = await api.getQcLabCpoStatistics(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      final unloadingStats = await api.getUnloadingCpoStatistics(
        token,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      // Load manager check statistics
      final managerStats = await api.getManagerCheckStatistics(token);

      // Fetch tickets for each stage to count pending checks
      final samplingTickets = await api.getManagerCheckTickets(
        token,
        "CPO",
        stage: "sampling",
      );

      final labTickets = await api.getManagerCheckTickets(
        token,
        "CPO",
        stage: "lab",
      );

      final unloadingTickets = await api.getManagerCheckTickets(
        token,
        "CPO",
        stage: "unloading",
      );

      setState(() {
        totalSampleKeluar =
            sampleStats.data?.statistics?.total_truk_keluar ?? 0;

        totalLabKeluar = labStats.data?.statistics?.total_truk_keluar ?? 0;

        totalUnloadingKeluar =
            unloadingStats.data?.statistics?.total_truk_keluar ?? 0;

        // Extract manager check statistics by stage
        final byStage = managerStats.data?.by_stage;
        if (byStage != null) {
          final sampling = byStage['sampling'];
          final lab = byStage['lab'];
          final unloading = byStage['unloading'];

          samplingApprovedChecks = sampling?.approved ?? 0;
          labApprovedChecks = lab?.approved ?? 0;
          unloadingApprovedChecks = unloading?.approved ?? 0;
        }

        // Count pending checks (tickets without manager check)
        samplingPendingChecks =
            samplingTickets.data
                ?.where((t) => !(t.has_manager_check ?? false))
                .length ??
            0;
        labPendingChecks =
            labTickets.data
                ?.where((t) => !(t.has_manager_check ?? false))
                .length ??
            0;
        unloadingPendingChecks =
            unloadingTickets.data
                ?.where((t) => !(t.has_manager_check ?? false))
                .length ??
            0;
      });
    } catch (e) {
      print("ERROR LOAD STATISTICS: $e");
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ManagerHomeSwipe()),
                  );
                } else if (value == "POME") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeManagerPome()),
                  );
                } else if (value == "PK") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeManagerPk()),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "CPO",
                  enabled: halamanAktif != "CPO",
                  child: Text(
                    "CPO",
                    style: TextStyle(
                      color: halamanAktif == "CPO" ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "POME",
                  enabled: halamanAktif != "POME",
                  child: Text(
                    "POME",
                    style: TextStyle(
                      color: halamanAktif == "POME"
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "PK",
                  enabled: halamanAktif != "PK",
                  child: Text(
                    "PK",
                    style: TextStyle(
                      color: halamanAktif == "PK" ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ],
              child: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 34,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              loadStatistics();
            },
          ),
        ],
      ),

      // ------------------ DRAWER ------------------
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu VCF",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
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

      // ------------------ BODY ------------------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hai, Manager 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                "Selamat datang di VEHICLE CONTROL SYSTEM",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),

              Center(
                child: Column(
                  children: [
                    const Text(
                      "QC Sample CPO",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

              // ------------------ CAROUSEL GAMBAR ------------------
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
                          return _stageCard(
                            "QC Sampling CPO",
                            "assets/cpo.jpg",
                            imageHeight,
                            totalSampleKeluar,
                            samplingPendingChecks,
                            samplingApprovedChecks,
                          );
                        } else if (page == 1) {
                          return _stageCard(
                            "QC Lab CPO",
                            "assets/cpo.jpg",
                            imageHeight,
                            totalLabKeluar,
                            labPendingChecks,
                            labApprovedChecks,
                          );
                        }
                        return _stageCard(
                          "Unloading CPO",
                          "assets/cpo.jpg",
                          imageHeight,
                          totalUnloadingKeluar,
                          unloadingPendingChecks,
                          unloadingApprovedChecks,
                        );
                      },
                    ),
                    Positioned(
                      left: 0,
                      child: _circleNavBtn(
                        Icons.chevron_left_rounded,
                        prevPage,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: _circleNavBtn(
                        Icons.chevron_right_rounded,
                        nextPage,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _dot(i)),
              ),

              const SizedBox(height: 40),

              // ------------------ INFO CARD ------------------
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
                          _infoCard(
                            "Total Sample Truk Keluar",
                            "$totalSampleKeluar",
                          ),
                          _infoCard("Total LAB Truk Keluar", "$totalLabKeluar"),
                          _infoCard(
                            "Total Unloading Truk Keluar",
                            "$totalUnloadingKeluar",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoCard(
                        "Tanggal Hari Ini",
                        getTanggalIndonesia(),
                      ),
                    ),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
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
          ),
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
                      "Input Data CPO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                      MaterialPageRoute(
                        builder: (_) => const DataTrukCpoPage(),
                      ),
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
                        color: Colors.white,
                      ),
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
                      _optionItem(
                        "Sample",
                        Icons.science,
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token =
                              prefs.getString("jwt_token") ??
                              prefs.getString("token") ??
                              "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SpTiketManagerCPOPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),
                      _optionItem(
                        "QC Lab",
                        Icons.biotech,
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token =
                              prefs.getString("jwt_token") ??
                              prefs.getString("token") ??
                              "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LbTiketManagerCPOPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),
                      _optionItem(
                        "Unloading",
                        Icons.local_shipping,
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token =
                              prefs.getString("jwt_token") ??
                              prefs.getString("token") ??
                              "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UnTiketManagerCPOPage(
                                userId: "manager",
                                token: token,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _optionItem(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
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

  // ------------------ STAGE CARD (with statistics) ------------------
  Widget _stageCard(
    String label,
    String imageUrl,
    double height,
    int totalKeluar,
    int pendingChecks,
    int approvedChecks,
  ) {
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
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            // Gradient overlay for better text readability (only on image, not on statistics)
            // Positioned to stop before the statistics container area
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom:
                  80, // Leave space for statistics container (approximately 80px)
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
            ),
            // Stage label at top
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            // Statistics at bottom (fully opaque white, drawn last to ensure it's on top)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statItem("Total Keluar", "$totalKeluar", Colors.blue),
                        _statItem("Pending", "$pendingChecks", Colors.orange),
                        _statItem("Approved", "$approvedChecks", Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
