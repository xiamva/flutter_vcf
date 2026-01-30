import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
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
  bool _forceNotRelab = false;
  bool _isReloadingPhotos = false;

  /// File foto baru
  File? _image1, _image2, _image3, _image4;

  /// Foto lama jika hold (readonly)
  List<String> oldPhotos = [];

  /// Semua lab_records dari backend (counter 0,1,2)
  List<dynamic> _labRecords = [];

  bool _isDetailLoaded = false;

  final ImagePicker picker = ImagePicker();
  int get _currentSamplingCounter => widget.model.counter ?? 0;
  bool get _isRelab => widget.model.isRelab == true;
  bool get _isHoldRelab => isHoldCase && (widget.model.counter ?? 0) > 0;
  bool get _isHoldInitial => isHoldCase && (widget.model.counter ?? 0) == 0;



  // max 4 foto
  int _getMaxPhotoAllowed() => 4;

  @override
  void initState() {
    super.initState();

    api = ApiService(AppConfig.createDio(withLogging: true));

    final status = _derivePkStatus(widget.model);
    isHoldCase = status == "hold";

    debugPrint("=== INIT InputLabPKPage ===");
    debugPrint("Registration ID: ${widget.model.registrationId}");
    debugPrint("labStatus: ${widget.model.labStatus}");
    debugPrint("registStatus: ${widget.model.registStatus}");
    debugPrint("isRelab: ${widget.model.isRelab}");
    debugPrint("sampling counter: ${widget.model.counter}");
    debugPrint("derived status: $status");
    debugPrint("isHoldCase: $isHoldCase");
    debugPrint("=============================");

  //  if (isHoldCase) {
  //     _forceNotRelab = true;   
  //     isQcEnabled = true;     
  //   }


    if (_isRelab || isHoldCase) {
      _loadLabPkDetail();
    } else {
      _isDetailLoaded = true;
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

      setState(() {
        switch (index) {
          case 1: _image1 = file; break;
          case 2: _image2 = file; break;
          case 3: _image3 = file; break;
          case 4: _image4 = file; break;
        }
      });
    }
  }

  bool _hasAtLeastOnePhoto() {
    final imgs = [_image1, _image2, _image3, _image4];
    return imgs.any((e) => e != null);
  }

  Future<void> _loadLabPkDetail() async {
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => _isDetailLoaded = true);
        return;
      }

      final res = await api.getLabPkDetail(
        "Bearer $token",
        widget.model.registrationId ?? "",
      );

      if (res.success == true && res.data != null) {
        final records = res.data!.labRecords;

        if (records != null && records.isNotEmpty) {
          final sorted = List<dynamic>.from(records);
          sorted.sort((a, b) {
            final ca = (a.counter ?? 0) as int;
            final cb = (b.counter ?? 0) as int;
            return ca.compareTo(cb);
          });

          setState(() {
            _labRecords = sorted;
            _isDetailLoaded = true;

           if (isHoldCase) {
            final currentCounter = _currentSamplingCounter;

            final activeRecord = sorted.firstWhere(
              (e) => (e.counter ?? 0) == currentCounter,
              orElse: () => sorted.last,
            );

            ffaCtrl.text = activeRecord.ffa ?? "";
            moistCtrl.text = activeRecord.moisture ?? "";
            dirtCtrl.text = activeRecord.dirt ?? "";
            oilCtrl.text = activeRecord.oilContent ?? "";
            remarksCtrl.text = activeRecord.remarks ?? "";

            oldPhotos = activeRecord.photos
                    ?.map((p) => p.url ?? "")
                    .where((u) => u.isNotEmpty)
                    .toList() ??
                [];

            isQcEnabled = true;
          }

          });
        } else {
          setState(() => _isDetailLoaded = true);
        }
      } else {
        setState(() => _isDetailLoaded = true);
      }
    } catch (e) {
      debugPrint("Load PK Lab Detail error: $e");
      setState(() => _isDetailLoaded = true);
    }
  }
  
  Future<void> _reloadOldPhotos() async {
    if (_isReloadingPhotos) return;
    setState(() => _isReloadingPhotos = true);
    try {
      await _loadLabPkDetail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar berhasil dimuat ulang')),
      );
    } catch (e) {
      debugPrint('Reload old photos error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat ulang gambar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isReloadingPhotos = false);
    }
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

              if (!_isDetailLoaded)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                _buildLabSection(),
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


 Widget _buildRelabHoldSection() {
  final current = _currentSamplingCounter;

  // Semua yang lama → readonly
  final readonlyRecords = _labRecords.where((rec) {
    return (rec.counter ?? 0) < current;
  }).toList()
    ..sort((a, b) =>
        ((a.counter ?? 0) as int).compareTo((b.counter ?? 0) as int));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // LAB AWAL + RE-LAB 1 (READONLY)
      for (var rec in readonlyRecords) _labReadonlyCard(rec),

      const SizedBox(height: 12),


      _relabInputCard(current),

      const SizedBox(height: 20),
      _buildActionButtons(),
    ],
  );
}
Widget _buildLabSection() {
  // HOLD LAB AWAL (counter 0)
  if (_isHoldInitial) {
    return _buildHoldSection();
  }

  // HOLD RE-LAB (counter 1 atau 2)
  if (_isHoldRelab) {
    return _buildRelabHoldSection();
  }

  // RELAB NORMAL
  if (_isRelab) {
    return _buildRelabSection();
  }

  // NORMAL
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          "Input QC Data",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      _inputFormFields(),
      _cameraSection(),
      const SizedBox(height: 20),
      _buildActionButtons(),
    ],
  );
}



  Widget _buildHoldSection() {
    final int counter = widget.model.counter ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Jika sedang HOLD RELAB → tampilkan hasil awal (counter 0)
        if (counter >= 1)
          for (var rec in _labRecords.where((e) => (e.counter ?? 0) == 0))
            _labReadonlyCard(rec),

        const SizedBox(height: 16),

        Text(
          counter >= 1 ? "Input QC Data (Hold Re-Lab)" : "Input QC Data (Hold)",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),

        _inputFormFields(),

        // Jika ada foto relab lama, tetap tampilkan
        _oldPhotoGallery(),

        _cameraSection(),

        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }



Widget _buildRelabSection() {
  final current = _currentSamplingCounter;

  final previousRecords = _labRecords.where((rec) {
    return (rec.counter ?? 0) < current;
  }).toList()
    ..sort((a, b) {
      return ((a.counter ?? 0) as int).compareTo((b.counter ?? 0) as int);
    });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var rec in previousRecords) _labReadonlyCard(rec),
      const SizedBox(height: 12),
      _relabInputCard(current),
      const SizedBox(height: 20),
      _buildActionButtons(),
    ],
  );
}


  Widget _inputFormFields() {
  return Column(
    children: [
      /// Row 1 — FFA & Dirt
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, right: 6),
              child: _numberField("FFA (%)", ffaCtrl),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 6),
              child: _numberField("Dirt (%)", dirtCtrl),
            ),
          ),
        ],
      ),

      /// Row 2 — Moisture & Oil Content
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, right: 6),
              child: _numberField("Moisture (%)", moistCtrl),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 6),
              child: _numberField("Oil Content (%)", oilCtrl),
            ),
          ),
        ],
      ),

      /// Row 3 — Remarks (full width)
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: _input("Remarks", remarksCtrl, maxLines: 2),
      ),
    ],
  );
}


 Widget _labReadonlyCard(dynamic record) {
  final int counter = record.counter ?? 0;

  String title = counter == 0 ? "Hasil Lab Awal" : "Hasil Re-Lab $counter";

  final String ffa = record.ffa ?? "-";
  final String moist = record.moisture ?? "-";
  final String dirt = record.dirt ?? "-";
  final String oil = record.oilContent ?? "-";
  final String remarks = record.remarks ?? "";

  final List<String> photoUrls =
      (record.photos as List<dynamic>?)
              ?.map((p) => p.url as String? ?? "")
              .where((u) => u.isNotEmpty)
              .toList() ??
          [];

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.black26),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),

        /// ROW 1 — FFA & Dirt
        Row(
          children: [
            Expanded(child: _readonlyInputBox("FFA (%)", ffa)),
            const SizedBox(width: 8),
            Expanded(child: _readonlyInputBox("Dirt (%)", dirt)),
          ],
        ),
        const SizedBox(height: 8),

        /// ROW 2 — Moisture & Oil Content
        Row(
          children: [
            Expanded(child: _readonlyInputBox("Moisture (%)", moist)),
            const SizedBox(width: 8),
            Expanded(child: _readonlyInputBox("Oil Content (%)", oil)),
          ],
        ),
        const SizedBox(height: 8),

        /// Remarks full width
        _readonlyInputBox("Remarks", remarks),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Foto", style: TextStyle(fontWeight: FontWeight.w500)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isReloadingPhotos)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    tooltip: 'Reload gambar',
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () async {
                      await _reloadOldPhotos();
                    },
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        _readonlyPhotoGrid(photoUrls),
      ],
    ),
  );
}

Widget _readonlyInputBox(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black38),
        ),
        child: Text(value),
      ),
    ],
  );
}



  Widget _readonlyPhotoGrid(List<String> photos) {
    return Row(
      children: List.generate(4, (i) {
        final hasPhoto = i < photos.length;
        final url = hasPhoto ? photos[i] : null;

        return Expanded(
          child: Container(
            height: 75,
            margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black38),
            ),
            child: url == null
                ? const Icon(Icons.image_not_supported)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Widget _relabInputCard(int counter) {
    final title = counter == 1 ? "Input Re-Lab 1" : "Input Re-Lab 2";

    return Container(
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),

          _inputFormFields(),
          const SizedBox(height: 12),

          _cameraSection(),
        ],
      ),
    );
  }

  Widget _cameraSection() {
    return Container(
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isReloadingPhotos)
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      tooltip: 'Reload gambar',
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () async {
                        await _reloadOldPhotos();
                      },
                    ),

                  Checkbox(
                    value: isCameraEnabled,
                    onChanged: isQcEnabled
                        ? (v) {
                            setState(() {
                              isCameraEnabled = v ?? false;
                              if (!isCameraEnabled) {
                                _image1 = _image2 = _image3 = _image4 = null;
                              }
                            });
                          }
                        : null,
                  ),
                ],
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
    );
  }

  Widget _cameraBox(int i, File? f) => GestureDetector(
        onTap: (isCameraEnabled && isQcEnabled) ? () => _getImage(i) : null,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
              color: (isCameraEnabled && isQcEnabled)
                  ? Colors.white
                  : Colors.grey.shade400,
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

  Widget _buildActionButtons() {
    return Row(
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
    );
  }

  bool _validateInputs(String status) {
    // CASE HOLD — data sudah ada, tidak wajib foto baru
    if (isHoldCase) {
      if (ffaCtrl.text.isEmpty ||
          moistCtrl.text.isEmpty ||
          dirtCtrl.text.isEmpty ||
          oilCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data FFA, Moisture, Dirt & Oil Content kosong")),
        );
        return false;
      }

      return true;
    }

    // Normal lab & relab wajib diisi
    if (ffaCtrl.text.isEmpty ||
        moistCtrl.text.isEmpty ||
        dirtCtrl.text.isEmpty ||
        oilCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data QC dulu")),
      );
      return false;
    }

    // Minimal 1 foto
    if (!_hasAtLeastOnePhoto()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Minimal ambil 1 foto hasil lab")),
      );
      return false;
    }

    return true;
  }

  // Submit
  Future<void> _submit(String status) async {
    if (!_validateInputs(status)) return;

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

      // Foto baru
      final photos = <String>[];
      final images = [_image1, _image2, _image3, _image4];

      for (final img in images) {
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
        "status": status,
        if (photos.isNotEmpty) "photos": photos,
      };

      debugPrint("Payload:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final res = await api.submitLabPk("Bearer $token", payload);

      if (!mounted) return;

      if (res.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("QC Lab PK ${status.toUpperCase()} berhasil dikirim")),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.response?.data['message'] ?? e.message}")),
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
    if (!_validateInputs(status)) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
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


  Widget _readonlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
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

  Widget _oldPhotoGallery() {
    if (oldPhotos.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Foto Sebelumnya (Readonly)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isReloadingPhotos)
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    tooltip: 'Reload gambar sebelumnya',
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () async {
                      await _reloadOldPhotos();
                    },
                  ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: List.generate(4, (i) {
            final has = i < oldPhotos.length;
            final url = has ? oldPhotos[i] : null;

            return Expanded(
              child: Container(
                height: 75,
                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54),
                  color: Colors.grey.shade300,
                ),
                child: url == null
                    ? const Icon(Icons.image_not_supported)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Old image load error: $error');
                            return const Icon(Icons.broken_image);
                          },
                        ),
                      ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

 
  Widget _plateWidget(String plate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Plat Kendaraan", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            plate,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

 
  Widget _input(String label, TextEditingController c, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        readOnly: !isQcEnabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isQcEnabled ? Colors.white : Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _numberField(String label, TextEditingController c) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onPressed,
      {bool disabled = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? Colors.grey : color,
      ),
      onPressed: disabled || _isSubmitting ? null : onPressed,
      child: Text(label),
    );
  }
}
