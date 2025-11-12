import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPkData extends StatefulWidget {
  final String platKendaraan;
  const AddPkData({super.key, required this.platKendaraan});

  @override
  State<AddPkData> createState() => _AddPkDataState();
}

class _AddPkDataState extends State<AddPkData> {
  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;
  File? _image5;
  
  bool _isCameraEnabled = false; // kontrol checkbox

  final ImagePicker picker = ImagePicker();

  Future<void> _getImage(int index) async {
    if (!_isCameraEnabled) return; // kalau tidak diceklis, jangan jalan

    var cameraStatus = await Permission.camera.request();
    var photosStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && photosStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          switch (index) {
            case 1:
              _image1 = File(pickedFile.path);
              break;
            case 2:
              _image2 = File(pickedFile.path);
              break;
            case 3:
              _image3 = File(pickedFile.path);
              break;
            case 4:
              _image4 = File(pickedFile.path);
              break;
            case 5:
              _image5 = File(pickedFile.path);
              break;
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin kamera & foto dibutuhkan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String tiketTimbang = '';
    final String namaSupir = '';
    final String kodeKomoditi = '';
    final String namaKomoditi = '';
    final String kodeVendor = '';
    final String namaVendor = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Sample QC'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Plat Kendaraan', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.platKendaraan, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            _buildReadOnlyField('Tiket Timbang', tiketTimbang),
            _buildReadOnlyField('Supir', namaSupir),
            _buildReadOnlyField('Kode Komoditi', kodeKomoditi),
            _buildReadOnlyField('Nama Komoditi', namaKomoditi),
            _buildReadOnlyField('Kode Vendor', kodeVendor),
            _buildReadOnlyField('Nama Vendor', namaVendor),

            const SizedBox(height: 16),

            // ✅ Checkbox bisa dicentang
            CheckboxListTile(
              value: _isCameraEnabled,
              activeColor: Colors.green,
              title: const Text('Ambil Gambar'),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  _isCameraEnabled = val ?? false;

                  // Optional: reset gambar kalau uncheck
                  if (!_isCameraEnabled) {
                    _image1 = null;
                    _image2 = null;
                    _image3 = null;
                    _image4 = null;
                    _image5 = null;
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // Layout kamera 1-2-2
            Column(
              children: [
                // Baris pertama: 1 kamera
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImagePickerBox(1, _image1),
                  ],
                ),
                const SizedBox(height: 16),

                // Baris kedua: 2 kamera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImagePickerBox(2, _image2),
                    _buildImagePickerBox(3, _image3),
                  ],
                ),
                const SizedBox(height: 16),

                // Baris ketiga: 2 kamera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImagePickerBox(4, _image4),
                    _buildImagePickerBox(5, _image5),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Image1: $_image1");
                  debugPrint("Image2: $_image2");
                  debugPrint("Image3: $_image3");
                  debugPrint("Image4: $_image4");
                  debugPrint("Image5: $_image5");
                  // TODO: simpan ke database / server
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value.isEmpty ? '"$label"' : value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerBox(int index, File? imageFile) {
    final bool isEnabled = _isCameraEnabled;
    return GestureDetector(
      onTap: isEnabled ? () => _getImage(index) : null,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(6),
          color: isEnabled ? Colors.grey[100] : Colors.grey[400],
        ),
        child: imageFile == null
            ? Icon(Icons.camera_alt,
                size: 32, color: isEnabled ? Colors.black : Colors.black45)
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
