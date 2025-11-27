import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/qc_lab_cpo_vehicle.dart';

class InputLabCPOPage extends StatefulWidget {
  final String token;
  final QcLabCpoVehicle model;

  const InputLabCPOPage({
    super.key,
    required this.token,
    required this.model,
  });

  @override
  State<InputLabCPOPage> createState() => _InputLabCPOPageState();
}

class _InputLabCPOPageState extends State<InputLabCPOPage> {
  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController ivCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  late ApiService api;
  bool _isSubmitting = false;

  bool isHoldCase = false;
  bool isQcCheckboxEnabled = false;
  bool isQcEnabled = false;
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

  debugPrint("lab_status: ${widget.model.lab_status}");
  debugPrint("regist_status: ${widget.model.regist_status}");
  
   final rawStatus = (widget.model.lab_status ?? widget.model.regist_status ?? "")
    .toLowerCase();

    isHoldCase = rawStatus.contains("hold");

  debugPrint("rawStatus = $rawStatus");
  debugPrint("isHoldCase = $isHoldCase");


    if (isHoldCase) {
      isQcEnabled = true;
      isQcCheckboxEnabled = true;
      _loadHoldData();  
    } else {
      isQcEnabled = true;
      isQcCheckboxEnabled = false;
    }


    debugPrint("=== INIT InputLabCPOPage ===");
    debugPrint("Token: ${widget.token}");
    debugPrint("Registration ID: ${widget.model.registration_id}");
    debugPrint("Lab Status: ${widget.model.lab_status}");
    debugPrint("=============================");
  }

  @override
  void dispose() {
    ffaCtrl.dispose();
    moistCtrl.dispose();
    dobCtrl.dispose();
    ivCtrl.dispose();
    remarksCtrl.dispose();
    super.dispose();
  }

  /// Load data ketika tiket HOLD → isi lagi FFA, Moisture, DOBI, IV, Remarks
  Future<void> _loadHoldData() async {
    try {
      debugPrint("Load Hold Data untuk ${widget.model.registration_id}");
      final res = await api.getLabCpoDetail(
        "Bearer ${widget.token}",
        widget.model.registration_id ?? "",
      );

      if (res.success && res.data != null) {
        setState(() {
          ffaCtrl.text = "${res.data!.ffa ?? ""}";
          moistCtrl.text = "${res.data!.moisture ?? ""}";
          dobCtrl.text = "${res.data!.dobi ?? ""}";
          ivCtrl.text = "${res.data!.iv ?? ""}";
          remarksCtrl.text = "${res.data!.remarks ?? ""}";
          // Foto sengaja TIDAK di-load kembali (sesuai permintaan),
          // supaya ketika HOLD dibuka lagi, user input foto baru.
          _image1 = _image2 = _image3 = _image4 = null;
        });
      }
    } catch (e) {
      debugPrint("Load hold data error: $e");
    }
  }

  Future<void> _getImage(int index) async {
    if (!isCameraEnabled) return;

    final statuses = await [Permission.camera].request();
    if (!statuses[Permission.camera]!.isGranted) return;

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final f = File(picked.path);
      debugPrint("Gambar diambil: ${f.path}");
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
        dobCtrl.text.isEmpty ||
        ivCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi FFA, Moisture, DOBI & IV dulu")),
      );
      return false;
    }

    final ffa = double.tryParse(ffaCtrl.text.replaceAll(',', '.'));
    final moisture = double.tryParse(moistCtrl.text.replaceAll(',', '.'));
    final dobi = double.tryParse(dobCtrl.text.replaceAll(',', '.'));
    final iv = double.tryParse(ivCtrl.text.replaceAll(',', '.'));

    if (ffa == null || moisture == null || dobi == null || iv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input angka tidak valid")),
      );
      return false;
    }

    // Validasi range masuk akal
    if (ffa < 0 ||
        ffa > 100 ||
        moisture < 0 ||
        moisture > 100 ||
        dobi < 0 ||
        dobi > 10 ||
        iv < 0 ||
        iv > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data yang dimasukin tidak sesuai standar")),
      );
      return false;
    }

    // Harus minimal 1 foto
    if (!_hasAtLeastOnePhoto()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Ambil minimal 1 foto hasil lab sebelum lanjut")),
      );
      return false;
    }

    return true;
  }

  Future<void> _submit(String status) async {
    if (!_validateInputs()) return;

    setState(() => _isSubmitting = true);

    try {
      debugPrint("Mulai Submit QC Lab CPO");
      debugPrint("Status QC: $status");

      final photos = <String>[];
      for (final img in [_image1, _image2, _image3, _image4]) {
        if (img != null) {
          final bytes = await img.readAsBytes();
          photos.add("data:image/jpeg;base64,${base64Encode(bytes)}");
        }
      }

      String adjustedRegistStatus =
          (widget.model.regist_status ?? "").toLowerCase();
      if (adjustedRegistStatus == "qc_lab_hold") {
        adjustedRegistStatus = "qc_lab";
      }

      final payload = {
        "registration_id": widget.model.registration_id,
        "regist_status": adjustedRegistStatus,
        "ffa": double.parse(ffaCtrl.text.replaceAll(',', '.')),
        "moisture": double.parse(moistCtrl.text.replaceAll(',', '.')),
        "dobi": double.parse(dobCtrl.text.replaceAll(',', '.')),
        "iv": double.parse(ivCtrl.text.replaceAll(',', '.')),
        "remarks": remarksCtrl.text.trim(),
        "status": status,
        if (photos.isNotEmpty) "photos": photos,
      };

      debugPrint("Payload dikirim:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final res = await api.submitLabCpo("Bearer ${widget.token}", payload);

      if (!mounted) return;
      if (res.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "QC Lab ${status.toUpperCase()} berhasil dikirim")),
        );
        Navigator.pop(context, {
          "registration_id": widget.model.registration_id,
          "plate_number": widget.model.plate_number,
          "wb_ticket_no": widget.model.wb_ticket_no,
          "lab_status": status,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit QC Lab")),
        );
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.response?.data}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error: ${e.response?.data['message'] ?? e.message}")),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    final info = {
      "Plat Kendaraan": widget.model.plate_number ?? "-",
      "Nomor Tiket Timbang": widget.model.wb_ticket_no ?? "-",
      "Supir": widget.model.driver_name ?? "-",
      "Kode Komoditi": widget.model.commodity_code ?? "-",
      "Nama Komoditi": widget.model.commodity_name ?? "-",
      "Kode Vendor": widget.model.vendor_code ?? "-",
      "Nama Vendor": widget.model.vendor_name ?? "-",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input QC Lab CPO"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _plateWidget(widget.model.plate_number ?? "-"),
              _readonlyBox("Nomor Tiket Timbang", widget.model.wb_ticket_no ?? "-"),
              _readonlyBox("Supir", widget.model.driver_name ?? "-"),
              _readonlyBox("Kode Komoditi", widget.model.commodity_code ?? "-"),
              _readonlyBox("Nama Komoditi", widget.model.commodity_name ?? "-"),
              _readonlyBox("Kode Vendor", widget.model.vendor_code ?? "-"),
              _readonlyBox("Nama Vendor", widget.model.vendor_name ?? "-"),

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
                  Expanded(child: _numberField("DOBI", dobCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField("IV", ivCtrl)),
                ],
              ),
              const SizedBox(height: 8),

              // Remarks full width
              _input("Remarks", remarksCtrl, maxLines: 2),

              const SizedBox(height: 12),

              // ======================
              // KOTAK BESAR FOTO LAB
              // ======================
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
                      () => _confirm("Hold", "Tahan QC?", "hold"),
                      disabled: isHoldCase, // 🔥 otomatis disable kalau sudah HOLD
                    ),
                  _btn("Approve", Colors.green,
                      () => _confirm("Approve", "Setujui QC?", "approved")),
                  _btn("Reject", Colors.red,
                      () => _confirm("Reject", "Tolak QC?", "rejected")),
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

  Widget _readonlyBox(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(v),
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


  Widget _input(String label, TextEditingController c, {int maxLines = 1}) {
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

  /// Field angka untuk grid 2 kolom
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
