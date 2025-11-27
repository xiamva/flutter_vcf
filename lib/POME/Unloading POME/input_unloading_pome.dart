import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/unloading_pome_model.dart';
import 'package:flutter_vcf/models/master/response/master_tank_response.dart';
import 'package:flutter_vcf/models/master/response/master_hole_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class InputUnloadingPOMEPage extends StatefulWidget {
  final String token;
  final UnloadingPomeModel model;

  const InputUnloadingPOMEPage({
    super.key,
    required this.model,
    required this.token,
  });

  @override
  State<InputUnloadingPOMEPage> createState() => _InputUnloadingPOMEPageState();
}

class _InputUnloadingPOMEPageState extends State<InputUnloadingPOMEPage> {
  final TextEditingController remarksCtrl = TextEditingController();
  final double baseFont = 15;

  bool disableHoldButton = false;
  bool unloadingStarted = false;
  bool _isSubmitting = false;
  bool _isCameraEnabled = false;
  bool isReadOnly = false;

  File? _image1, _image2, _image3, _image4;

  final ImagePicker picker = ImagePicker();
  late Dio _dio;
  late ApiService api;

  List<TankItem> tanks = [];
  List<HoleItem> holes = [];
  int? selectedTankId;
  int? selectedHoleId;

  /// URL foto yang sudah tersimpan (kalau tiket HOLD)
  List<String> _existingPhotos = [];

  @override
  void initState() {
    super.initState();
    _dio = Dio()
      ..options.baseUrl = 'http://172.30.64.69:8000/api/'
      ..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ));
    api = ApiService(_dio);

    _loadMasterData();
    _loadExistingUnloadingIfHold();
  }

  bool _isHoldTicket() {
    final unloadingStatus =
        (widget.model.unloading_status ?? '').toLowerCase().trim();
    final registStatus =
        (widget.model.regist_status ?? '').toLowerCase().trim();

    if (unloadingStatus == 'hold' || unloadingStatus == 'unloading_hold') {
      return true;
    }
    if (registStatus == 'unloading_hold') return true;
    return false;
  }

  Future<void> _loadExistingUnloadingIfHold() async {
    if (!_isHoldTicket()) return;

    try {
      final detail = await api.getUnloadingPomeDetail(
        "Bearer ${widget.token}",
        widget.model.registration_id!,
      );

      final d = detail.data;

      setState(() {
        disableHoldButton = true; 
        isReadOnly = false; 
        unloadingStarted = true;
        _isCameraEnabled = false;

        selectedTankId = d?.tankId;
        selectedHoleId = d?.holeId;
        remarksCtrl.text = d?.remarks ?? "";

        // ambil url foto existing 
        _existingPhotos = (d?.photos ?? [])
            .map<String>((p) => p.url ?? "")
            .where((e) => e.isNotEmpty)
            .toList();

        _image1 = _image2 = _image3 = _image4 = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error load detail HOLD: $e")),
      );
    }
  }

  Future<void> _loadMasterData() async {
    try {
      final tankResp = await api.getAllTanks("Bearer ${widget.token}");
      final holeResp = await api.getAllHoles("Bearer ${widget.token}");
      if (!mounted) return;
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

  Future<void> _getImage(int index) async {
    if (!_isCameraEnabled || isReadOnly) return;

    final statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();

    if (!statuses[Permission.camera]!.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akses kamera ditolak")),
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final f = File(picked.path);
    setState(() {
      if (index == 1) _image1 = f;
      if (index == 2) _image2 = f;
      if (index == 3) _image3 = f;
      if (index == 4) _image4 = f;
    });
  }

  /// Collect 4 foto maksimal → base64
  List<String> _collectPhotosBase64() {
    final imgs =
        [_image1, _image2, _image3, _image4].where((e) => e != null).toList();
    return imgs.map((f) {
      final bytes = f!.readAsBytesSync();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    }).toList();
  }

  Future<bool> _startUnloading() async {
    if (_isHoldTicket()) return true;
    if (unloadingStarted) return true;

    if (selectedTankId == null || selectedHoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih Tank dan Hole dulu")),
      );
      return false;
    }

    final imgs =
        [_image1, _image2, _image3, _image4].where((e) => e != null).toList();
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

  Future<void> _confirmAndSubmit(String status) async {
    if (!await _startUnloading()) return;

    await _showConfirmDialog(
      title: "Konfirmasi Simpan",
      message: "Apakah anda yakin menyimpan data Unloading?",
      onConfirm: () => _submit(status),
    );
  }

  Future<void> _confirmAndFinish() async {
    if (!await _startUnloading()) return;

    await _showConfirmDialog(
      title: "Konfirmasi Selesai",
      message: "Apakah anda yakin menyelesaikan unloading?",
      onConfirm: _finishUnloading,
    );
  }

  Future<void> _submit(String status) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final photos = _collectPhotosBase64();

    final payload = {
      "registration_id": widget.model.registration_id,
      "status": status,
      "tank_id": selectedTankId,
      "hole_id": selectedHoleId,
      "remarks": remarksCtrl.text.trim(),
      if (photos.isNotEmpty) "photos": photos,
    };

    try {
      final res = await api.submitUnloadingPome(
        "Bearer ${widget.token}",
        payload,
      );

      if (res.success) {
        if (!mounted) return;
        Navigator.pop(context, {
          "registration_id": widget.model.registration_id,
          "plate_number": widget.model.plate_number,
          "wb_ticket_no": widget.model.wb_ticket_no,
          "status": status,
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _finishUnloading() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final photos = _collectPhotosBase64();

    final payload = {
      "registration_id": widget.model.registration_id,
      "status": "approved",
      "tank_id": selectedTankId,
      "hole_id": selectedHoleId,
      "remarks": remarksCtrl.text.trim(),
      if (photos.isNotEmpty) "photos": photos,
    };

    try {
      final res = await api.submitUnloadingPome(
        "Bearer ${widget.token}",
        payload,
      );

      if (res.success) {
        if (!mounted) return;
        Navigator.pop(context, {
          "registration_id": widget.model.registration_id,
          "plate_number": widget.model.plate_number,
          "wb_ticket_no": widget.model.wb_ticket_no,
          "status": "approved",
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal finish")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error finish: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = {
      "Plat Kendaraan": widget.model.plate_number,
      "Nomor Tiket Timbang": widget.model.wb_ticket_no,
      "Supir": widget.model.driver_name,
      "Kode Komoditi": widget.model.commodity_code,
      "Nama Komoditi": widget.model.commodity_name,
      "Kode Vendor": widget.model.vendor_code,
      "Nama Vendor": widget.model.vendor_name,
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Input Unloading POME",
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
            ...info.entries.map((e) => _fieldReadOnly(e.key, e.value)).toList(),
            const SizedBox(height: 12),

            // Dropdown Tank
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
              onChanged:
                  isReadOnly ? null : (v) => setState(() => selectedTankId = v),
            ),

            const SizedBox(height: 12),

            // Dropdown Hole
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
              onChanged:
                  isReadOnly ? null : (v) => setState(() => selectedHoleId = v),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: remarksCtrl,
              maxLines: 3,
              decoration: _dec("Remarks"),
              style: TextStyle(fontSize: baseFont),
            ),

            const SizedBox(height: 12),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _btn(
                  "Hold",
                  Colors.orange,
                  () => _confirmAndSubmit("hold"),
                  enabled: !disableHoldButton,
                ),
                _btn(
                  "Finish",
                  Colors.blue,
                  _confirmAndFinish,
                ),
                _btn(
                  "Reject",
                  Colors.red,
                  () => _confirmAndSubmit("rejected"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _fieldReadOnly(String label, String? value) {
    if (label == "Plat Kendaraan") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: baseFont)),
            const SizedBox(height: 6),
            Text(
              value ?? "",
              style: TextStyle(
                fontSize: baseFont + 1,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

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
              border: Border.all(color: Colors.black26),
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value ?? "",
              style: TextStyle(fontSize: baseFont),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, Color c, VoidCallback onTap,
          {bool enabled = true}) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: c),
        onPressed: _isSubmitting || !enabled ? null : onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      );

  Widget _box(int index, File? f) => GestureDetector(
        onTap: _isCameraEnabled && !isReadOnly ? () => _getImage(index) : null,
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
                    child: Image.file(
                      f,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      );
}
