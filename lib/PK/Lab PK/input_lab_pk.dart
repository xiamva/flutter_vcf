import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pk/response/qc_lab_pk_vehicles_response.dart';

class InputLabPKPage extends StatefulWidget {
  final QcLabPkVehicle model;

  const InputLabPKPage({
    super.key,
    required this.model,
  });

  @override
  State<InputLabPKPage> createState() => _InputLabPKPageState();
}

class _InputLabPKPageState extends State<InputLabPKPage> {
  // controller input QC
  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController dirtCtrl = TextEditingController();
  final TextEditingController oilCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  late ApiService api;
  bool _isSubmitting = false;

  bool isHoldCase = false;
  bool isQcEnabled = true;
  bool isCameraEnabled = false;

  File? _image1, _image2, _image3, _image4;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final dio = Dio()
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    api = ApiService(dio);

    final status = _derivePkStatus(widget.model);
    isHoldCase = status == "hold";

    debugPrint("=== INIT InputLabPKPage ===");
    debugPrint("Registration ID: ${widget.model.registrationId}");
    debugPrint("labStatus: ${widget.model.labStatus}");
    debugPrint("registStatus: ${widget.model.registStatus}");
    debugPrint("isRelab: ${widget.model.isRelab}");
    debugPrint("counter: ${widget.model.counter}");
    debugPrint("derived status: $status");
    debugPrint("isHoldCase: $isHoldCase");
    debugPrint("=============================");

    if (isHoldCase || widget.model.isRelab == true) {
      _loadLabPkDetail();
    }

  }

  @override
  void dispose() {
    ffaCtrl.dispose();
    moistCtrl.dispose();
    dirtCtrl.dispose();
    oilCtrl.dispose();
    remarksCtrl.dispose();
    super.dispose();
  }

  /// Tentukan status PK dari kombinasi lab_status, is_relab, counter
  String _derivePkStatus(QcLabPkVehicle v) {
    final lab = (v.labStatus ?? "").toLowerCase();

    if (["approved", "hold", "rejected"].contains(lab)) {
      return lab;
    }

    if (v.isRelab == true) {
      if (v.counter == 1) return "resampling_1";
      if (v.counter == 2) return "resampling_2";
    }

    return "pending";
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _getImage(int index) async {
    if (!isCameraEnabled) return;

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin kamera diperlukan")),
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final file = File(picked.path);
      debugPrint("Gambar diambil: ${file.path}");
      setState(() {
        switch (index) {
          case 1:
            _image1 = file;
            break;
          case 2:
            _image2 = file;
            break;
          case 3:
            _image3 = file;
            break;
          case 4:
            _image4 = file;
            break;
        }
      });
    }
  }

  bool _hasAtLeastOnePhoto() {
    return _image1 != null ||
        _image2 != null ||
        _image3 != null ||
        _image4 != null;
  }

  bool _validateInputs() {
    if (ffaCtrl.text.isEmpty ||
        moistCtrl.text.isEmpty ||
        dirtCtrl.text.isEmpty ||
        oilCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Lengkapi FFA, Moisture, Dirt & Oil Content dulu")),
      );
      return false;
    }

    final ffa = double.tryParse(ffaCtrl.text.replaceAll(',', '.'));
    final moisture = double.tryParse(moistCtrl.text.replaceAll(',', '.'));
    final dirt = double.tryParse(dirtCtrl.text.replaceAll(',', '.'));
    final oil = double.tryParse(oilCtrl.text.replaceAll(',', '.'));

    if (ffa == null || moisture == null || dirt == null || oil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input angka tidak valid")),
      );
      return false;
    }

    // Range dasar biar ga ngawur
    if (ffa < 0 ||
        ffa > 100 ||
        moisture < 0 ||
        moisture > 100 ||
        dirt < 0 ||
        dirt > 100 ||
        oil < 0 ||
        oil > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai di luar batas wajar")),
      );
      return false;
    }

    if (!_hasAtLeastOnePhoto()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Ambil minimal 1 foto hasil lab sebelum lanjut")),
      );
      return false;
    }

    return true;
  }
  Future<void> _loadLabPkDetail() async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final res = await api.getLabPkDetail(
        "Bearer $token",
        widget.model.registrationId ?? "",
      );

      if (res.success == true && res.data != null) {
        final records = res.data!.labRecords;
        if (records != null && records.isNotEmpty) {
          final last = records.last;

          setState(() {
            ffaCtrl.text = last.ffa ?? "";
            moistCtrl.text = last.moisture ?? "";
            dirtCtrl.text = last.dirt ?? "";
            oilCtrl.text = last.oilContent ?? "";
            remarksCtrl.text = last.remarks ?? "";

            if (last.photos != null && last.photos!.isNotEmpty) {
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Load PK Lab Detail error: $e");
    }
  }

  Future<void> _submit(String status) async {
    if (!_validateInputs()) return;

    setState(() => _isSubmitting = true);

    try {
      final token = await _getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token tidak ditemukan.")),
        );
        return;
      }

      debugPrint("Mulai Submit QC Lab PK, status: $status");

      final photos = <String>[];
      for (final img in [_image1, _image2, _image3, _image4]) {
        if (img != null) {
          final bytes = await img.readAsBytes();
          photos.add("data:image/jpeg;base64,${base64Encode(bytes)}");
        }
      }

      final payload = {
        "registration_id": widget.model.registrationId,
        "ffa": double.parse(ffaCtrl.text.replaceAll(',', '.')),
        "moisture": double.parse(moistCtrl.text.replaceAll(',', '.')),
        "dirt": double.parse(dirtCtrl.text.replaceAll(',', '.')),
        "oil_content": double.parse(oilCtrl.text.replaceAll(',', '.')),
        "remarks": remarksCtrl.text.trim(),
        "status": status, // "approved" / "hold" / "rejected"
        if (photos.isNotEmpty) "photos": photos,
      };

      debugPrint("Payload PK:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final res = await api.submitLabPk("Bearer $token", payload);

      if (!mounted) return;

      if (res.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "QC Lab PK ${status.toUpperCase()} berhasil dikirim")),
        );
        Navigator.pop(context, {
          "registration_id": widget.model.registrationId,
          "plate_number": widget.model.plateNumber,
          "wb_ticket_no": widget.model.wbTicketNo,
          "lab_status": status,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit QC Lab PK")),
        );
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.response?.data}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Error: ${e.response?.data['message'] ?? e.message}"),
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

  void _confirm(String title, String msg, String status) {
    if (!_validateInputs()) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
              _submit(status);
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input QC Lab PK"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _plateWidget(model.plateNumber ?? "-"),
              _readonlyBox("Nomor Tiket Timbang", model.wbTicketNo ?? "-"),
              _readonlyBox("Supir", model.driverName ?? "-"),
              _readonlyBox("Kode Komoditi", model.commodityCode ?? "-"),
              _readonlyBox("Nama Komoditi", model.commodityName ?? "-"),
              _readonlyBox("Kode Vendor", model.vendorCode ?? "-"),
              _readonlyBox("Nama Vendor", model.vendorName ?? "-"),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "Input QC Data",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(child: _numberField("FFA (%)", ffaCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField("Moisture (%)", moistCtrl)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _numberField("Dirt (%)", dirtCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField("Oil Content (%)", oilCtrl)),
                ],
              ),

              const SizedBox(height: 8),
              _input("Remarks", remarksCtrl, maxLines: 2),

              const SizedBox(height: 12),

              // KOTAK FOTO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ambil Gambar Hasil Lab",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Checkbox(
                          value: isCameraEnabled,
                          onChanged: isQcEnabled
                              ? (v) {
                                  setState(() {
                                    isCameraEnabled = v ?? false;
                                    if (!isCameraEnabled) {
                                      _image1 = _image2 =
                                          _image3 = _image4 = null;
                                    }
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _cameraBox(1, _image1)),
                        const SizedBox(width: 8),
                        Expanded(child: _cameraBox(2, _image2)),
                        const SizedBox(width: 8),
                        Expanded(child: _cameraBox(3, _image3)),
                        const SizedBox(width: 8),
                        Expanded(child: _cameraBox(4, _image4)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _btn(
                    "Hold",
                    Colors.orange,
                    () => _confirm("Hold", "Tahan QC PK?", "hold"),
                    disabled: isHoldCase,
                  ),
                  _btn(
                    "Approve",
                    Colors.green,
                    () => _confirm("Approve", "Setujui QC PK?", "approved"),
                  ),
                  _btn(
                    "Reject",
                    Colors.red,
                    () => _confirm("Reject", "Tolak QC PK?", "rejected"),
                  ),
                ],
              ),
            ],
          ),

          if (_isSubmitting)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _readonlyBox(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value),
            ),
          ],
        ),
      );

  Widget _plateWidget(String plate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plat Kendaraan",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            plate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        readOnly: !isQcEnabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isQcEnabled ? Colors.white : Colors.grey.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _numberField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: c,
        readOnly: !isQcEnabled,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isQcEnabled ? Colors.white : Colors.grey.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _cameraBox(int i, File? f) => GestureDetector(
        onTap: isCameraEnabled ? () => _getImage(i) : null,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
              color: isCameraEnabled ? Colors.white : Colors.grey.shade400,
            ),
            child: f == null
                ? const Icon(Icons.camera_alt)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      f,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      );

  Widget _btn(
    String label,
    Color color,
    VoidCallback onPressed, {
    bool disabled = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? Colors.grey : color,
      ),
      onPressed: disabled || _isSubmitting || !isQcEnabled ? null : onPressed,
      child: Text(label),
    );
  }
}
