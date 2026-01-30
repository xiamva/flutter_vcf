import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/response/submit_qc_sampling_response.dart';

class AddCPODataPage extends StatefulWidget {
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

  const AddCPODataPage({
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
  State<AddCPODataPage> createState() => _AddCPODataPageState();
}

class _AddCPODataPageState extends State<AddCPODataPage> {
  File? _image1, _image2, _image3, _image4;
  bool _isCameraEnabled = false;
  bool _isLoading = false;
  final ImagePicker picker = ImagePicker();
  late ApiService api;

  List<String> _uploadedPhotoUrls = [];

  @override
  void initState() {
    api = ApiService(AppConfig.createDio());
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


  Future<void> saveCpoSample() async {
  try {
    FocusScope.of(context).unfocus(); 
    setState(() => _isLoading = true);

    final photos = <String>[];

    for (final img in [_image1, _image2, _image3, _image4]) {
      if (img != null) {
        final compressed = await compressImage(img);
        final bytes = await compressed.readAsBytes();
        photos.add(base64Encode(bytes));
      }
    }

    if (photos.isEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ambil minimal 1 foto")),
      );
      return;
    }

    final payload = {
      "registration_id": widget.registrationId,
      "photos": photos,
    };

    final SubmitQcSamplingResponse res =
        await api.submitQcSampling("Bearer ${widget.token}", payload);

    setState(() => _isLoading = false);

    if (res.success && res.data?.photos != null) {
      final urls = res.data!.photos!
          .map((p) => p.url ?? "")
          .where((url) => url.isNotEmpty)
          .toList();

      setState(() {
        _uploadedPhotoUrls = urls;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sample tersimpan dan foto diupload")),
      );

      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, {
          "registration_id": widget.registrationId,
          "tiket_no": widget.tiketNo,
          "plat": widget.platKendaraan,
          "status": "done",
          "has_sampling_data": true,
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message ?? "Gagal simpan")),
      );
    }
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } 
}

  
Future<File> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    "${file.path}_compressed.jpg",
    quality: 70,
    minWidth: 1024,
  );

  return File(result!.path);
}


  Future<void> _showConfirmDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Simpan"),
          content: const Text("Apakah anda yakin menyimpan data Sample QC?"),
          actionsAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );

    if (confirm == true) saveCpoSample();
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
        title: const Text("Input Sample CPO"),
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
              onPressed: _isLoading ? null : _showConfirmDialog,
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

          // Loading overlay
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
    final isDisabled = !_isCameraEnabled;

    return GestureDetector(
      onTap: isDisabled ? null : () => _getImage(i),
      child: Container(
        width: 70,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
        ),
        child: img == null
            ? Icon(
                Icons.camera_alt,
                size: 24,
                color: isDisabled ? Colors.grey.shade600 : Colors.black54,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(img, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
