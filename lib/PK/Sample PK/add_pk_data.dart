import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/PK/Sample%20PK/sample_qc_pk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pk/response/qc_sampling_pk_sample_response.dart';

class AddPKDataPage extends StatefulWidget {
  final String userId;
  final String token;
  final String registrationId;
  final String platKendaraan;
  final String tiketNo;
  final String vendorCode;
  final String vendorName;
  final String commodityCode;
  final String commodityName;

  const AddPKDataPage({
    super.key,
    required this.userId,
    required this.token,
    required this.registrationId,
    required this.platKendaraan,
    required this.tiketNo,
    required this.vendorCode,
    required this.vendorName,
    required this.commodityCode,
    required this.commodityName,
  });

  @override
  State<AddPKDataPage> createState() => _AddPKDataPageState();
}

class _AddPKDataPageState extends State<AddPKDataPage> {
  late ApiService api;
  bool loading = true;

  // simple in-memory cache for downloaded images to avoid repeated network hits
  final Map<String, Uint8List> _imageCache = {};

  // track which section counters are currently reloading
  final Set<int> _reloadingCounters = {};

  List<QcSamplingPkRecord> records = [];

  int? activeCounter;
  List<File?> newPhotos = List<File?>.filled(4, null);
  List<bool> sectionChecked = [false, false, false];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final res = await api.getQcSamplingPkSample(
        "Bearer ${widget.token}",
        widget.registrationId,
      );

      final rawRecords = res.data?.sampling_records ?? <QcSamplingPkRecord>[];

      int? tmpActive;
      if (rawRecords.isEmpty) {
        // belum ada sampling sama sekali → counter 0 aktif
        tmpActive = 0;
      } else {
        final pending =
            rawRecords.where((r) => r.sampled_at == null).toList();
        if (pending.isNotEmpty) {
          tmpActive = pending.first.counter;
        } else {
          tmpActive = null;
        }
      }

      setState(() {
        records = rawRecords;
        activeCounter = tmpActive;
        newPhotos = List<File?>.filled(4, null);
        sectionChecked = [false, false, false];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Load error: $e")));
    }
  }

  Future<void> pickPhoto(int index) async {
    if (activeCounter == null) return;

    final cam = await Permission.camera.request();
    if (!cam.isGranted) return;

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        newPhotos[index] = File(picked.path);
      });
    }
  }

  Future<void> submitSample() async {
    if (activeCounter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada sample pending.")),
      );
      return;
    }

    final filledCount = newPhotos.where((f) => f != null).length;
    if (filledCount < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Minimal 2 foto wajib di-upload.")),
      );
      return;
    }

    final encodedPhotos = newPhotos
        .where((f) => f != null)
        .map((f) => base64Encode(f!.readAsBytesSync()))
        .toList();

    final payload = {
      "registration_id": widget.registrationId,
      "photos": encodedPhotos,
    };

    try {
      await api.submitQcSamplingPK("Bearer ${widget.token}", payload);

      Navigator.pop(context, true);  
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submit error: $e")));
    }
  }

  Future<void> _showConfirmDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Simpan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Apakah anda yakin menyimpan data Sample QC?"),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );  

    if (confirm == true) {
      submitSample();
    }
  }

  /// foto lama (readonly) 
Widget _oldPhotoBox(QcSamplingPkPhoto p) {
  final String url = p.url;

  if (url.isEmpty) {
    return const Icon(Icons.broken_image);
  }
  final fixedUrl = Uri.parse(url).toString();

  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: FutureBuilder<Uint8List?>(
      future: _fetchImageBytes(fixedUrl),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[200],
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final bytes = snap.data;
        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(bytes, fit: BoxFit.cover);
        }

        return const Icon(Icons.broken_image);
      },
    ),
  );
}

/// Try to download image bytes with simple retry and cache.
Future<Uint8List?> _fetchImageBytes(String url) async {
  try {
    if (_imageCache.containsKey(url)) return _imageCache[url];

    // Use a plain Dio instance to fetch raw bytes with a short timeout.
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 10); // 10s
    dio.options.connectTimeout = Duration(seconds: 5); // 5s

    const int maxAttempts = 2;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final resp = await dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes, headers: {"Connection": "close"}),
        );

        final data = Uint8List.fromList(resp.data ?? <int>[]);
        if (data.isNotEmpty) {
          _imageCache[url] = data;
          return data;
        }
      } catch (e) {
        debugPrint('Image fetch attempt $attempt failed for $url: $e');
        if (attempt == maxAttempts) rethrow;
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
  } catch (e) {
    debugPrint('Failed to fetch image bytes: $e');
  }
  return null;
}

Future<void> _reloadPhotosForCounter(int counter) async {
  setState(() {
    _reloadingCounters.add(counter);
  });

  try {
    final rec = _record(counter);
    final photos = rec?.photos ?? [];
    for (var p in photos) {
      final key = p.url.isNotEmpty ? Uri.parse(p.url).toString() : '';
      if (key.isNotEmpty) _imageCache.remove(key);
    }

    // reload records from server (will refresh photo URLs)
    await loadDetail();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reload error: $e')));
  } finally {
    if (mounted) {
      setState(() {
        _reloadingCounters.remove(counter);
      });
    }
  }
}




 
  Widget _photoBoxPK(int index, bool enabled) {
    final img = newPhotos[index];

    return GestureDetector(
      onTap: enabled ? () => pickPhoto(index) : null,
      child: Container(
        width: 70,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? Colors.grey.shade400 : Colors.grey.shade500,
          ),
        ),
        child: img == null
            ? Icon(
                Icons.camera_alt,
                size: 24,
                color: enabled ? Colors.black54 : Colors.grey.shade600,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(img, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _newPhotoBox(int index, bool enabled) {
    final f = newPhotos[index];
    return GestureDetector(
      onTap: enabled ? () => pickPhoto(index) : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? Colors.black45 : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.grey.shade300,
        ),
        child: f == null
            ? Icon(
                Icons.camera_alt,
                size: 28,
                color: enabled ? Colors.grey[800] : Colors.grey[500],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(f, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey.shade200,
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// record berdasarkan counter
  QcSamplingPkRecord? _record(int counter) {
    try {
      return records.firstWhere((r) => r.counter == counter);
    } catch (_) {
      return null;
    }
  }

  Widget _section(int counter) {
    final record = _record(counter);
    final List<QcSamplingPkPhoto> photos = record?.photos ?? [];

    bool show = false;

    if (counter == 0) {
      show = true;
    } else {
      if (record != null || activeCounter == counter) {
        show = true;
      }
    }
    if (!show) return const SizedBox.shrink();

    final bool isReadonly =
        photos.isNotEmpty && record?.sampled_at != null;

    String title;
    if (counter == 0) {
      title = "Ambil Gambar Sampling";
    } else if (counter == 1) {
      title = "Ambil Gambar Re-Sample 1";
    } else {
      title = "Ambil Gambar Re-Sample 2";
    }

    // checkbox hanya relevan kalau section ini yang aktif dan belum readonly
    final bool isActiveEditable =
        !isReadonly && activeCounter == counter;

    final bool checkboxValue = sectionChecked[counter];

    final bool enableCapture = isActiveEditable && checkboxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_reloadingCounters.contains(counter))
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    tooltip: 'Reload gambar',
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () => _reloadPhotosForCounter(counter),
                  ),

                if (isActiveEditable)
                  Checkbox(
                    value: checkboxValue,
                    onChanged: (val) {
                      setState(() {
                        sectionChecked[counter] = val ?? false;
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),

        if (isReadonly)
          // Tampilkan foto lama (readonly)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: photos.length,
              itemBuilder: (_, i) => _oldPhotoBox(photos[i]),
            ),
          )
        else if (isActiveEditable)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _photoBoxPK(0, enableCapture),
                _photoBoxPK(1, enableCapture),
                _photoBoxPK(2, enableCapture),
                _photoBoxPK(3, enableCapture),
              ],
            ),
          )
        else
          // section non-aktif / belum diminta resampling
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: const Text(
              "Menunggu permintaan re-sampling.",
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Sample PK"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _readonlyField("Plat Kendaraan", widget.platKendaraan),
          _readonlyField("Tiket Timbang", widget.tiketNo),
          _readonlyField("Kode Vendor", widget.vendorCode),
          _readonlyField("Nama Vendor", widget.vendorName),
          _readonlyField("Kode Komoditi", widget.commodityCode),
          _readonlyField("Nama Komoditi", widget.commodityName),
          _section(0),
          _section(1),
          _section(2),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: activeCounter != null ? _showConfirmDialog : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  activeCounter != null ? Colors.blue : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              activeCounter == null
                  ? "Semua Sample Lengkap"
                  : "Simpan Sample",
            ),
          ),
        ],
      ),
    );
  }
}
