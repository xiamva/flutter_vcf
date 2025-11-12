import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/unloading_cpo_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
  

class InputUnloadingCPOPage extends StatefulWidget {
  final String token;
  final UnloadingCpoModel model;

  const InputUnloadingCPOPage({
    super.key,
    required this.model,
    required this.token,
  });

  @override
  State<InputUnloadingCPOPage> createState() => _InputUnloadingCPOPageState();
}

class _InputUnloadingCPOPageState extends State<InputUnloadingCPOPage> {
  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController tankNoCtrl = TextEditingController();
  final TextEditingController holeNoCtrl = TextEditingController();

  File? _image1, _image2, _image3, _image4;
  bool _isCameraEnabled = false;
  bool _isSubmitting = false;
  bool unloadingStarted = false; // track status start

  final ImagePicker picker = ImagePicker();
  late ApiService api;

  @override
  void initState() {
    super.initState();

    final dio = Dio()
      ..interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ));

    api = ApiService(dio);
  }

  Future<void> _getImage(int index) async {
  if (!_isCameraEnabled) return;

  final statuses = await [
    Permission.camera,  
    Permission.photos,
    Permission.storage,
  ].request();

  if (statuses[Permission.camera]!.isGranted &&
      (statuses[Permission.photos]?.isGranted ?? true)) {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        final f = File(picked.path);
        switch (index) {
          case 1: _image1 = f; break;
          case 2: _image2 = f; break;
          case 3: _image3 = f; break;
          case 4: _image4 = f; break;
        }
      });
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Izin kamera & galeri dibutuhkan")),
    );
  }
}


  Future<void> _startUnloading() async {
    if (tankNoCtrl.text.isEmpty || holeNoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi Nomor Tangki & Nomor Lubang dulu")),
      );
      return;
    }

    final payload = {
      "registration_id": widget.model.registration_id,
      "tank_no": tankNoCtrl.text.trim(),
      "hole_no": holeNoCtrl.text.trim(),
    };

    print("=== START PAYLOAD ===");
    print(payload);

    try {
      final res = await api.startUnloading("Bearer ${widget.token}", payload);

      print("=== START RESPONSE ===");
      print(res);

      if (res.success) {
        setState(() => unloadingStarted = true);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Unloading dimulai")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res.message ?? "Gagal start")));
      }
    } catch (e) {
      print("=== START ERROR ===");
      print(e);
    }
  }

  bool _guardStart() {
    if (!unloadingStarted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Mulai unloading dulu")));
      return false;
    }
    return true;
  }

  Future<void> _submit(String status) async {
    if (!_guardStart()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final payload = {
      "registration_id": widget.model.registration_id,
      "unloading_status": status,
      "tank_no": tankNoCtrl.text.trim(),
      "hole_no": holeNoCtrl.text.trim(),
      "remarks": remarksCtrl.text.trim(),
    };

    print("=== PAYLOAD SENT ===");
    print(payload);

    try {
      final res = await api.submitUnloadingStatus(
        "Bearer ${widget.token}",
        payload,
      );

      print("=== SERVER RESPONSE ===");
      print(res);

      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" $status berhasil")),
        );
         Navigator.pop(context, {
          "registration_id": widget.model.registration_id,
          "plate_number": widget.model.plate_number,
          "wb_ticket_no": widget.model.wb_ticket_no,
          "status": status, // hold / rejected
        });
      }
    } catch (e) {
      if (e is DioException) {
        print("=== SERVER ERROR BODY ===");
        print(e.response?.data);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _finishUnloading() async {
    if (!_guardStart()) return;

    setState(() => _isSubmitting = true);

    final payload = {"registration_id": widget.model.registration_id};

    print("=== FINISH PAYLOAD SENT ===");
    print(payload);

    try {
      final res = await api.finishUnloading("Bearer ${widget.token}", payload);

      print("=== FINISH RESPONSE ===");
      print(res);

      if (res.success) {
        Navigator.pop(context, {
          "registration_id": widget.model.registration_id,
          "plate_number": widget.model.plate_number,
          "wb_ticket_no": widget.model.wb_ticket_no,
          "status": "approved",
        });
      }
    } catch (e) {
      if (e is DioException) print(e.response?.data);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showConfirmDialog({
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
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
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Ya"),
          ),
        ],
      );
    },
  );
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
        title: const Text("Input Unloading CPO"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...info.entries.map((e) => _fieldReadOnly(e.key, e.value ?? "")),
            const SizedBox(height: 12),

            _fieldInput("Nomor Tangki", tankNoCtrl),
            const SizedBox(height: 8),
            _fieldInput("Nomor Lubang", holeNoCtrl),
            const SizedBox(height: 12),
            _fieldInput("Remarks", remarksCtrl, maxLines: 3),

            CheckboxListTile(
              value: _isCameraEnabled,
              title: const Text("Ambil Gambar"),
              onChanged: (value) async {
                print("=== Checkbox clicked: $value ===");
                print("Tank: ${tankNoCtrl.text}, Hole: ${holeNoCtrl.text}");

                // pastikan textfield commit dulu
                FocusScope.of(context).unfocus();

                // Validasi input tangki & lubang
                if (value == true &&
                    (tankNoCtrl.text.isEmpty || holeNoCtrl.text.isEmpty)) {
                  print("Masih kosong tank/hole, checkbox dibatalkan");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Isi Nomor Tangki dan Nomor Lubang dulu")),
                  );
                  return;
                }

                setState(() {
                  _isCameraEnabled = value ?? false;
                });

                print("Setelah setState > _isCameraEnabled: $_isCameraEnabled");

                // Start unloading sekali saja
                if (value == true && !unloadingStarted) {
                  print("Memulai proses unloading...");
                  await _startUnloading();
                  setState(() => unloadingStarted = true);
                  print(" unloadingStarted = $unloadingStarted");
                }

                if (value == false) {
                  print("Checkbox off, reset foto");
                  setState(() {
                    _image1 = _image2 = _image3 = _image4 = null;
                  });
                }
              },
            ),





            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _box(1, _image1),
                _box(2, _image2),
                _box(3, _image3),
                _box(4, _image4),
              ],
            ),
            const SizedBox(height: 28),

            // Buttons ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               _btn("Hold", Colors.orange,
                unloadingStarted ? () {
                  _showConfirmDialog(
                    title: "Konfirmasi Simpan",
                    message: "Apakah anda yakin menahan proses unloading (Hold)?",
                    onConfirm: () => _submit("hold"),
                  );
                } : null),
               _btn("Finish", Colors.blue,
                unloadingStarted ? () {
                  _showConfirmDialog(
                    title: "Konfirmasi Selesai",
                    message: "Apakah anda yakin menyelesaikan unloading?",
                    onConfirm: _finishUnloading,
                  );
                } : null),
               _btn("Reject", Colors.red,
                unloadingStarted ? () {
                  _showConfirmDialog(
                    title: "Konfirmasi Tolak",
                    message: "Apakah anda yakin REJECT unloading ini?",
                    onConfirm: () => _submit("rejected"),
                  );
                } : null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String text, Color c, VoidCallback? fn) => ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: c),
        onPressed: _isSubmitting ? null : fn,
        child: Text(text),
      );

  Widget _fieldReadOnly(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          
          // Jika label = "Plat Kendaraan", tampilkan teks polos
          if (label == "Plat Kendaraan")
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )
          else
            // Field lain tetap pakai box abu-abu
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value, style: const TextStyle(color: Colors.black87)),
            ),
        ],
      ),
    );


  Widget _fieldInput(String label, TextEditingController c,
          {int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
      );

  Widget _box(int i, File? f) => GestureDetector(
        onTap: _isCameraEnabled
          ? () {
              print(" Camera tapped slot: $i");
              _getImage(i);
            }
          : () {
              print(" Tap ignored, _isCameraEnabled = false");
            },
        child: Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
            color: _isCameraEnabled ? Colors.white : Colors.grey.shade400,
          ),
          child: f == null
              ? const Icon(Icons.camera_alt)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(f, fit: BoxFit.cover),
                ),
        ),
      );
}
