import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/response/submit_qc_sampling_pome_response.dart';

class AddPOMEDataPage extends StatefulWidget {
  final String userId;
  final String token;
  final String registrationId;
  final String platKendaraan;
  final String tiketNo;
  final String driver;
  final String commodityCode;
  final String commodityName;
  final String vendorCode;
  final String vendorName;

  const AddPOMEDataPage({
    super.key,
    required this.userId,
    required this.token,
    required this.registrationId,
    required this.platKendaraan,
    required this.tiketNo,
    required this.driver,
    required this.commodityCode,
    required this.commodityName,
    required this.vendorCode,
    required this.vendorName,
  });

  @override
  State<AddPOMEDataPage> createState() => _AddPOMEDataPageState();
}

class _AddPOMEDataPageState extends State<AddPOMEDataPage> {
  File? _image1, _image2, _image3, _image4;
  bool _isCameraEnabled = false;
  bool _isLoading = false;
  final ImagePicker picker = ImagePicker();
  late ApiService api;
  List<String> _uploadedPhotoUrls = [];

  @override
  void initState() {
    api = ApiService(Dio());
    super.initState();
  }

  Future<void> _getImage(int index) async {
    if (!_isCameraEnabled) return;

    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        switch (index) {
          case 1:
            _image1 = File(picked.path);
            break;
          case 2:
            _image2 = File(picked.path);
            break;
          case 3:
            _image3 = File(picked.path);
            break;
          case 4:
            _image4 = File(picked.path);
            break;
        }
      });
    }
  }

  Future<void> savePomeSample() async {
    try {
      setState(() => _isLoading = true);

      final photos = <String>[];
      for (final img in [_image1, _image2, _image3, _image4]) {
        if (img != null) {
          final bytes = await img.readAsBytes();
          photos.add("data:image/jpeg;base64,${base64Encode(bytes)}");
        }
      }

      if (photos.isEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ambil minimal 1 foto terlebih dahulu")),
        );
        return;
      }

      final payload = {
        "registration_id": widget.registrationId,
        "photos": photos,
      };

      final SubmitQcSamplingPomeResponse res =
          await api.submitQcSamplingPome("Bearer ${widget.token}", payload);

      setState(() => _isLoading = false);

      if (res.success && res.data?.photos != null) {
        final urls = res.data!.photos!
            .map((p) => p.url ?? "")
            .where((url) => url.isNotEmpty)
            .toList();

        setState(() => _uploadedPhotoUrls = urls);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sample POME tersimpan dan foto diupload")),
        );

        Navigator.pop(context, {
          "registration_id": widget.registrationId,
          "tiket_no": widget.tiketNo,
          "plat": widget.platKendaraan,
          "status": "done",
          "has_sampling_data": true,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Gagal menyimpan sample")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _confirmSave() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Simpan"),
        content: const Text("Yakin ingin menyimpan data sample POME?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm == true) savePomeSample();
  }

  @override
  Widget build(BuildContext context) {
    final info = {
      "Nomor Tiket Timbang": widget.tiketNo,
      "Plat Kendaraan": widget.platKendaraan,
      "Supir": widget.driver,
      "Kode Komoditi": widget.commodityCode,
      "Nama Komoditi": widget.commodityName,
      "Kode Vendor": widget.vendorCode,
      "Nama Vendor": widget.vendorName,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Sample POME"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...info.entries.map((e) => _readOnlyField(e.key, e.value)),
              const SizedBox(height: 10),

              CheckboxListTile(
                value: _isCameraEnabled,
                onChanged: (v) {
                  setState(() {
                    _isCameraEnabled = v!;
                    if (!v) _image1 = _image2 = _image3 = _image4 = null;
                  });
                },
                title: const Text("Ambil Gambar Sampling"),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _photoBox(1, _image1),
                    _photoBox(2, _image2),
                    _photoBox(3, _image3),
                    _photoBox(4, _image4),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _confirmSave,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Sample"),
              ),

              const SizedBox(height: 20),

              if (_uploadedPhotoUrls.isNotEmpty) ...[
                const Text(
                  "Foto yang sudah diupload:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _uploadedPhotoUrls
                      .map(
                        (url) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),

          if (_isLoading)
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

  Widget _readOnlyField(String label, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Text(v),
          ),
        ],
      ),
    );
  }

  Widget _photoBox(int i, File? img) {
    final disabled = !_isCameraEnabled;

    return GestureDetector(
      onTap: disabled ? null : () => _getImage(i),
      child: Container(
        width: 75,
        height: 105,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: disabled ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
        ),
        child: img == null
            ? Icon(
                Icons.camera_alt,
                size: 26,
                color: disabled ? Colors.grey.shade600 : Colors.black54,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(img, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
