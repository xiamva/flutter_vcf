import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/master/response/master_hole_response.dart';
import 'package:flutter_vcf/models/master/response/master_tank_response.dart';
import 'package:flutter_vcf/models/pk/unloading_pk_model.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_detail_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class InputUnloadingPKPage extends StatefulWidget {
  final String token;
  final UnloadingPkModel model;

  const InputUnloadingPKPage({
    super.key,
    required this.token,
    required this.model,
  });

  @override
  State<InputUnloadingPKPage> createState() => _InputUnloadingPKPageState();
}

class _InputUnloadingPKPageState extends State<InputUnloadingPKPage> {
  final TextEditingController remarksCtrl = TextEditingController();

  final double baseFont = 15;
  bool _isSubmitting = false;

  // Mode flag
  bool isReadOnly = false;
  bool disableHoldButton = false;
  bool unloadingStarted = false;

  // Camera / photo
  bool _isCameraEnabled = false;
  File? _image1, _image2, _image3, _image4;
  final ImagePicker picker = ImagePicker();

  // API
  late Dio _dio;
  late ApiService api;

  // Master data
  List<TankItem> tanks = [];
  List<HoleItem> holes = [];
  int? selectedTankId;
  int? selectedHoleId;

  // Existing photos (dari backend)
  List<String> _existingPhotos = [];

  @override
  void initState() {
    super.initState();

    _dio = Dio()
      ..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ));

    api = ApiService(_dio);

    _loadMasterData();
    _loadExistingUnloading();
  }

  /// Ambil data tank & hole
  Future<void> _loadMasterData() async {
    try {
      final tankResp = await api.getAllTanks("Bearer ${widget.token}");
      final holeResp = await api.getAllHoles("Bearer ${widget.token}");

      setState(() {
        tanks = tankResp.data;
        holes = holeResp.data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal load data tank & hole")),
      );
    }
  }

  /// Load detail unloading PK (untuk cek: lagi HOLD, RESAMPLING, atau RE-UNLOADING)
  Future<void> _loadExistingUnloading() async {
    try {
      final res = await api.getUnloadingPkDetail(
        "Bearer ${widget.token}",
        widget.model.registrationId ?? "",
      );

      final d = res.data;
      if (d == null) return;

      final regStatus = (d.registStatus ?? "").toLowerCase().trim();
      final unloadingStatus = (d.unloadingStatus ?? "").toLowerCase().trim();
      final hasUnloading = d.hasUnloadingData == true;

      setState(() {
        if (hasUnloading) {
          unloadingStarted = true;

          selectedTankId = d.tankId;
          selectedHoleId = d.holeId;
          remarksCtrl.text = d.remarks ?? "";

          _existingPhotos = (d.photos ?? [])
              .map((p) => p.url ?? "")
              .where((u) => u.isNotEmpty)
              .toList();

       
          if (unloadingStatus == "hold" && regStatus == "qc_resampling") {
            // Lagi nunggu RESAMPLING → user cuma boleh lihat data
            isReadOnly = true;
            disableHoldButton = true;
            _isCameraEnabled = false;
          } else if (unloadingStatus == "hold" && regStatus == "unloading") {
            // RE-UNLOADING setelah relab → boleh lanjut isi
            isReadOnly = false;
            disableHoldButton = false;
          } else {
            isReadOnly = false;
          }
        } else {
          // Belum pernah unloading → mode NORMAL
          unloadingStarted = false;
          isReadOnly = false;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error load detail unloading: $e")),
      );
    }
  }

  /// Ambil foto kamera (UI tetap 4 slot, payload max 2 foto)
  Future<void> _getImage(int index) async {
    if (!_isCameraEnabled || isReadOnly) return;

    final statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();

    if (!statuses[Permission.camera]!.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akses kamera ditolak")),
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final f = File(picked.path);
    setState(() {
      switch (index) {
        case 1:
          _image1 = f;
          break;
        case 2:
          _image2 = f;
          break;
        case 3:
          _image3 = f;
          break;
        case 4:
          _image4 = f;
          break;
      }
    });
  }

  /// Kumpulkan foto sebagai base64 (MAX 2 FOTO sesuai backend)
  List<String> _collectPhotosBase64({int max = 2}) {
    final imgs = [_image1, _image2, _image3, _image4]
        .where((e) => e != null)
        .toList();

    final picked = imgs.take(max).map((f) {
      final bytes = f!.readAsBytesSync();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    }).toList();

    return picked;
  }

  /// Validasi awal sebelum start unloading (tank, hole, minimal 1 foto)
  Future<bool> _startUnloading() async {
    // Kalau lagi RESAMPLING pure (readOnly), langsung true tapi nanti tombol sudah nonaktif
    if (isReadOnly) return false;

    if (selectedTankId == null || selectedHoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih Tank dan Hole dulu")),
      );
      return false;
    }

    final imgs = [_image1, _image2, _image3, _image4]
        .where((e) => e != null)
        .toList();

    if (imgs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ambil minimal 1 foto dulu")),
      );
      return false;
    }

    setState(() => unloadingStarted = true);
    return true;
  }

  Future<void> _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: baseFont),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: baseFont),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  /// Hold / Reject / Approve (finish) → status sesuai
  Future<void> _confirmAndSubmit(String status) async {
    if (!await _startUnloading()) return;

    await _showConfirmDialog(
      title: "Konfirmasi Simpan",
      message: "Apakah anda yakin menyimpan data Unloading PK?",
      onConfirm: () => _submit(status),
    );
  }

  Future<void> _confirmAndFinish() async {
    if (!await _startUnloading()) return;

    await _showConfirmDialog(
      title: "Konfirmasi Selesai",
      message: "Apakah anda yakin menyelesaikan unloading PK?",
      onConfirm: () => _submit("approved"),
    );
  }

  Future<void> _submit(String status) async {
    if (_isSubmitting) return;
    if (isReadOnly) return;

    setState(() => _isSubmitting = true);

    try {
      final photos = _collectPhotosBase64(max: 2); // 🔥 backend max: 2

      final payload = {
        "registration_id": widget.model.registrationId,
        "status": status, // "approved" / "hold" / "rejected"
        "tank_id": selectedTankId,
        "hole_id": selectedHoleId,
        "remarks": remarksCtrl.text.trim(),
        if (photos.isNotEmpty) "photos": photos,
      };

      final res = await api.submitUnloadingPk(
        "Bearer ${widget.token}",
        payload,
      );

      if (!mounted) return;

      if (res.success == true) {
        // HOLD PK → backend langsung set regist_status = qc_resampling
        // APPROVED → wb_out
        // REJECTED → unloading_rejected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unloading PK ${status.toUpperCase()} berhasil"),
          ),
        );

        Navigator.pop(context, {
          "registration_id": widget.model.registrationId,
          "plate_number": widget.model.plateNumber,
          "wb_ticket_no": widget.model.wbTicketNo,
          "status": status,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit unloading PK")),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${e.response?.data['message'] ?? e.message}",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = {
      "Plat Kendaraan": widget.model.plateNumber,
      "Nomor Tiket Timbang": widget.model.wbTicketNo,
      "Supir": widget.model.driverName,
      "Kode Komoditi": widget.model.commodityCode,
      "Nama Komoditi": widget.model.commodityName,
      "Kode Vendor": widget.model.vendorCode,
      "Nama Vendor": widget.model.vendorName,
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Input Unloading PK",
          style: TextStyle(
            fontSize: baseFont + 4,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // INFO KENDARAAN (plat, supir, dll)
            ...info.entries
                .map((e) => _fieldReadOnly(e.key, e.value))
                .toList(),

            const SizedBox(height: 12),

            // DROPDOWN TANK
            DropdownButtonFormField<int>(
              value: selectedTankId,
              decoration: _dec("Pilih Tank"),
              items: tanks
                  .map(
                    (t) => DropdownMenuItem(
                      value: t.id,
                      child: Text(
                        "${t.tank_code} — ${t.tank_name}",
                        style: TextStyle(
                          fontSize: baseFont,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: isReadOnly
                  ? null
                  : (v) => setState(() => selectedTankId = v),
            ),

            const SizedBox(height: 12),

            // DROPDOWN HOLE
            DropdownButtonFormField<int>(
              value: selectedHoleId,
              decoration: _dec("Pilih Hole"),
              items: holes
                  .map(
                    (h) => DropdownMenuItem(
                      value: h.id,
                      child: Text(
                        "${h.hole_code} — ${h.hole_name}",
                        style: TextStyle(
                          fontSize: baseFont,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: isReadOnly
                  ? null
                  : (v) => setState(() => selectedHoleId = v),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: remarksCtrl,
              maxLines: 3,
              readOnly: isReadOnly,
              decoration: _dec("Remarks"),
              style: TextStyle(fontSize: baseFont),
            ),

            const SizedBox(height: 12),

                        const SizedBox(height: 12),

            // ===== CAMERA ENABLE CHECKBOX =====
            CheckboxListTile(
              value: _isCameraEnabled,
              title: Text(
                "Ambil Foto (Camera)",
                style: TextStyle(
                  fontSize: baseFont + 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onChanged: isReadOnly
                  ? null
                  : (v) {
                      setState(() => _isCameraEnabled = v ?? false);
                      if (v == false) {
                        setState(() {
                          _image1 = _image2 = _image3 = _image4 = null;
                        });
                      }
                    },
            ),

            if (!isReadOnly)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(child: _box(1, _image1)),
                    const SizedBox(width: 8),
                    Expanded(child: _box(2, _image2)),
                    const SizedBox(width: 8),
                    Expanded(child: _box(3, _image3)),
                    const SizedBox(width: 8),
                    Expanded(child: _box(4, _image4)),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // ===== BUTTON ROW =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _btn(
                  "Hold",
                  Colors.orange,
                  () => _confirmAndSubmit("hold"),
                  enabled: !disableHoldButton && !isReadOnly,
                ),
                _btn(
                  "Finish",
                  Colors.blue,
                  _confirmAndFinish,
                  enabled: !isReadOnly,
                ),
                _btn(
                  "Reject",
                  Colors.red,
                  () => _confirmAndSubmit("rejected"),
                  enabled: !isReadOnly,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _fieldReadOnly(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: baseFont)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
            child: Text(
              value ?? "-",
              style: TextStyle(fontSize: baseFont),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(
    String text,
    Color c,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: c,
        disabledBackgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: _isSubmitting || !enabled ? null : onTap,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  Widget _box(int index, File? f) {
    return GestureDetector(
      onTap:
          _isCameraEnabled && !isReadOnly ? () => _getImage(index) : null,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
            color: _isCameraEnabled && !isReadOnly
                ? Colors.white
                : Colors.grey.shade300,
          ),
          child: f == null
              ? const Icon(Icons.camera_alt, size: 30)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(f, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}

