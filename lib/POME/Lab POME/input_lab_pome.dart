import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/qc_lab_pome_vehicle.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class InputLabPOMEPage extends StatefulWidget {
  final String token;
  final QcLabPomeVehicle model;
  

  const InputLabPOMEPage({
    super.key,
    required this.token,
    required this.model,
  });

  @override
  State<InputLabPOMEPage> createState() => _InputLabPOMEPageState();
}

class _InputLabPOMEPageState extends State<InputLabPOMEPage> {
  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  late ApiService api;
  bool _isSubmitting = false;

  bool isHoldCase = false;
  bool isQcEnabled = false;
  bool isCameraEnabled = false;

  File? _image1, _image2, _image3, _image4;
  final ImagePicker picker = ImagePicker();
  bool _isPickingImage = false;

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

    // ==== DETEKSI HOLD ====
    debugPrint("lab_status POME: ${widget.model.labStatus}");
    final rawStatus = (widget.model.labStatus ?? "").toLowerCase();
    isHoldCase = rawStatus.contains("hold");
    debugPrint("rawStatus POME = $rawStatus");
    debugPrint("isHoldCase POME = $isHoldCase");

    // Untuk POME: QC selalu boleh diisi, baik tiket baru maupun HOLD
    isQcEnabled = true;

    if (isHoldCase) {
      _loadHoldData(); // isi FFA, Moisture, Remarks dari API
    }

    debugPrint("=== INIT InputLabPOMEPage ===");
    debugPrint("Token: ${widget.token}");
    debugPrint("Registration ID: ${widget.model.registrationId}");
    debugPrint("Lab Status: ${widget.model.labStatus}");
    debugPrint("================================");
  }

  @override
  void dispose() {
    ffaCtrl.dispose();
    moistCtrl.dispose();
    remarksCtrl.dispose();
    super.dispose();
  }

  /// Load data ketika tiket HOLD → isi lagi FFA, Moisture, Remarks
  Future<void> _loadHoldData() async {
    try {
      debugPrint("Load Hold Data POME untuk ${widget.model.registrationId}");
      final res = await api.getLabPomeDetail(
        "Bearer ${widget.token}",
        widget.model.registrationId ?? "",
      );

      if (res.success && res.data != null) {
        setState(() {
          ffaCtrl.text = res.data!.ffa ?? "";
          moistCtrl.text = res.data!.moisture ?? "";
          remarksCtrl.text = res.data!.remarks ?? "";
          // Foto TIDAK di-load ulang, supaya saat HOLD dibuka
          // user diminta ambil foto baru.
          _image1 = _image2 = _image3 = _image4 = null;
        });
      }
    } catch (e) {
      debugPrint("Load hold data POME error: $e");
    }
  }

  Future<void> _getImage(int index) async {
    if (!isCameraEnabled) return;

    // Prevent double call
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final statuses = await [Permission.camera].request();
      if (!statuses[Permission.camera]!.isGranted) {
        _isPickingImage = false;
        return;
      }

      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 65,
      );

      if (picked != null) {
        final f = File(picked.path);
        setState(() {
          switch (index) {
            case 1: _image1 = f; break;
            case 2: _image2 = f; break;
            case 3: _image3 = f; break;
            case 4: _image4 = f; break;
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      _isPickingImage = false;
    }
  }


  bool _validateInputs() {
    if (ffaCtrl.text.isEmpty || moistCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input FFA & Moisture wajib diisi")),
      );
      return false;
    }

    final ffa = double.tryParse(ffaCtrl.text.replaceAll(',', '.'));
    final moisture = double.tryParse(moistCtrl.text.replaceAll(',', '.'));

    if (ffa == null || moisture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("FFA dan Moisture harus angka")),
      );
      return false;
    }

    // Range dasar biar gak aneh-aneh
    if (ffa < 0 ||
        ffa > 100 ||
        moisture < 0 ||
        moisture > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Nilai FFA/Moisture di luar batas wajar")),
      );
      return false;
    }

    return true;
  }

  Future<String> compressToBase64(File img) async {
    final compressed = await FlutterImageCompress.compressWithFile(
      img.path,
      quality: 40,
      minWidth: 800,
      minHeight: 800,
      format: CompressFormat.jpeg,
    );

    final finalBytes = compressed ?? await img.readAsBytes();
    return base64Encode(finalBytes);
  }

  Future<void> _submit(String status) async {
    if (!_validateInputs()) return;

    setState(() => _isSubmitting = true);

    try {
      debugPrint("Mulai Submit QC Lab POME");
      debugPrint("Status QC POME: $status");

      // Konversi foto ke base64 (tanpa prefix, mengikuti implementasi lama)
      final photos = <String>[];
      for (final img in [_image1, _image2, _image3, _image4]) {
        if (img != null) {
          photos.add(await compressToBase64(img));
        }
      }

      final payload = {
        "registration_id": widget.model.registrationId,
        "ffa": double.parse(ffaCtrl.text.replaceAll(',', '.')),
        "moisture": double.parse(moistCtrl.text.replaceAll(',', '.')),
        "remarks": remarksCtrl.text.trim(),
        "status": status,
        if (photos.isNotEmpty) "photos": photos,
      };

      debugPrint("Payload POME dikirim:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final res = await api.submitLabPome(
        "Bearer ${widget.token}",
        payload,
      );

      if (!mounted) return;
      if (res.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("QC Lab POME ${status.toUpperCase()} berhasil dikirim"),
          ),
        );
        Navigator.pop(context, {
          "registration_id": widget.model.registrationId,
          "plate_number": widget.model.plateNumber,
          "wb_ticket_no": widget.model.wbTicketNo,
          "lab_status": status,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit POME Lab")),
        );
      }
    } on DioException catch (e) {
      debugPrint("DioException POME: ${e.response?.data}");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input QC Lab POME"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Plat seperti di CPO (tanpa shape)
              _plateWidget(widget.model.plateNumber ?? "-"),

              _readonlyBox(
                  "Nomor Tiket Timbang", widget.model.wbTicketNo ?? "-"),
              _readonlyBox("Supir", widget.model.driverName ?? "-"),
              _readonlyBox("Kode Vendor", widget.model.vendorCode ?? "-"),
              _readonlyBox("Nama Vendor", widget.model.vendorName ?? "-"),
              _readonlyBox(
                  "Kode Komoditi", widget.model.commodityCode ?? "-"),
              _readonlyBox(
                  "Nama Komoditi", widget.model.commodityName ?? "-"),
              _readonlyBox(
                  "Bruto Weight (Kg)", widget.model.brutoWeight ?? "-"),
              _readonlyBox("Vendor FFA", widget.model.vendorFfa ?? "-"),
              _readonlyBox(
                  "Vendor Moisture", widget.model.vendorMoisture ?? "-"),

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

              _numberInput("FFA (%)", ffaCtrl),
              _numberInput("Moisture (%)", moistCtrl),
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
                    // kalau sudah HOLD, tombol Hold di-disable
                    disabled: isHoldCase,
                  ),
                  _btn(
                    "Approve",
                    Colors.green,
                    () => _confirm("Approve", "Setujui QC?", "approved"),
                  ),
                  _btn(
                    "Reject",
                    Colors.red,
                    () => _confirm("Reject", "Tolak QC?", "rejected"),
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

  // ==================== WIDGET BANTUAN ====================

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

  Widget _numberInput(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
