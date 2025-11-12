import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/qc_lab_pome_vehicle.dart';

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
  bool isQcCheckboxEnabled = false;
  bool isQcEnabled = false;
  bool isCameraEnabled = false;

  File? _image1, _image2, _image3, _image4;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    api = ApiService(Dio());

    isHoldCase = (widget.model.labStatus ?? "").toLowerCase() == "hold";

    if (isHoldCase) {
      isQcEnabled = false;
      isQcCheckboxEnabled = true;
      _loadHoldData();
    } else {
      isQcEnabled = true;
      isQcCheckboxEnabled = false;
    }
  }

  Future<void> _loadHoldData() async {
    try {
      final res = await api.getLabPomeDetail(
        "Bearer ${widget.token}",
        widget.model.registrationId ?? "",
      );

      if (res.success && res.data != null) {
        setState(() {
          ffaCtrl.text = "${res.data!.ffa ?? ""}";
          moistCtrl.text = "${res.data!.moisture ?? ""}";
          remarksCtrl.text = "${res.data!.remarks ?? ""}";
        });
      }
    } catch (_) {}
  }

  Future<void> _getImage(int index) async {
    if (!isCameraEnabled) return;

    final statuses = await [Permission.camera].request();
    if (!statuses[Permission.camera]!.isGranted) return;

    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 65);
    if (picked != null) {
      final f = File(picked.path);
      setState(() {
        if (index == 1) _image1 = f;
        if (index == 2) _image2 = f;
        if (index == 3) _image3 = f;
        if (index == 4) _image4 = f;
      });
    }
  }

  bool _validateInputs() {
    if (ffaCtrl.text.isEmpty || moistCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input FFA & Moisture wajib diisi")),
      );
      return false;
    }

    if (double.tryParse(ffaCtrl.text.replaceAll(',', '.')) == null ||
        double.tryParse(moistCtrl.text.replaceAll(',', '.')) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("FFA dan Moisture harus angka")),
      );
      return false;
    }

    return true;
  }

  Future<void> _submit(String status) async {
    if (!_validateInputs()) return;

    setState(() => _isSubmitting = true);

    // Convert images to base64
    List<String> photos = [];
    for (var file in [_image1, _image2, _image3, _image4]) {
      if (file != null) {
        photos.add(base64Encode(await file.readAsBytes()));
      }
    }

    final payload = {
      "registration_id": widget.model.registrationId,
      "ffa": double.parse(ffaCtrl.text.replaceAll(',', '.')),
      "moisture": double.parse(moistCtrl.text.replaceAll(',', '.')),
      "remarks": remarksCtrl.text.trim(),
      "status": status,
      "photos": photos,
    };

    try {
      final res = await api.submitLabPome("Bearer ${widget.token}", payload);

      if (!mounted) return;
      if (res.success == true) {
        Navigator.pop(context, {"updated": true});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal submit POME Lab")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _confirm(String title, String msg, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tidak")),
          TextButton(
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
      "Nomor Tiket Timbang": widget.model.wbTicketNo ?? "-",
      "Plat Kendaraan": widget.model.plateNumber ?? "-",
      "Supir": widget.model.driverName ?? "-",
      "Kode Vendor": widget.model.vendorCode ?? "-",
      "Nama Vendor": widget.model.vendorName ?? "-",
      "Kode Komoditi": widget.model.commodityCode ?? "-",
      "Nama Komoditi": widget.model.commodityName ?? "-",
      "Transporter": widget.model.transporterName ?? "-",
      "Bruto Weight (Kg)": widget.model.brutoWeight ?? "-",
      "Vendor FFA": widget.model.vendorFfa ?? "-",
      "Vendor Moisture": widget.model.vendorMoisture ?? "-",
    };


    return Scaffold(
      appBar: AppBar(
        title: const Text("Input QC Lab POME"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...info.entries.map((e) => _readonlyBox(e.key, e.value)),
          const SizedBox(height: 10),

          CheckboxListTile(
            value: isQcEnabled,
            title: const Text("Input QC Data"),
            onChanged: isQcCheckboxEnabled
                ? (v) {
                    setState(() {
                      isQcEnabled = v ?? false;
                      if (!isQcEnabled) {
                        isCameraEnabled = false;
                        _image1 = _image2 = _image3 = _image4 = null;
                      }
                    });
                  }
                : null,
          ),

          _numberInput("FFA (%)", ffaCtrl),
          _numberInput("Moisture (%)", moistCtrl),
          _input("Remarks", remarksCtrl, maxLines: 2),

          CheckboxListTile(
            value: isCameraEnabled,
            title: const Text("Ambil Gambar"),
            onChanged: isQcEnabled
                ? (v) => setState(() => isCameraEnabled = v ?? false)
                : null,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _cameraBox(1, _image1),
              _cameraBox(2, _image2),
              _cameraBox(3, _image3),
              _cameraBox(4, _image4),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _btn("Hold", Colors.orange, () => _confirm("Hold", "Tahan QC?", "hold")),
              _btn("Approve", Colors.green, () => _confirm("Approve", "Setujui QC?", "approved")),
              _btn("Reject", Colors.red, () => _confirm("Reject", "Tolak QC?", "rejected")),
            ],
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        child: Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
            color: isCameraEnabled ? Colors.white : Colors.grey.shade400,
          ),
          child: f == null
              ? const Icon(Icons.camera_alt)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(f, fit: BoxFit.cover),
                ),
        ),
      );

  Widget _btn(String label, Color color, VoidCallback onPressed) => ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: _isSubmitting || !isQcEnabled ? null : onPressed,
        child: Text(label),
      );
}
