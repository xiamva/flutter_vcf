import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class InputLabPKPage extends StatefulWidget {
  final String userId;
  final String platKendaraan;

  const InputLabPKPage({
    super.key,
    required this.userId,
    required this.platKendaraan,
  });

  @override
  State<InputLabPKPage> createState() => _InputLabPKPageState();
}

class _InputLabPKPageState extends State<InputLabPKPage> {
  // controller input QC
  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController nettoCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController wrCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  // Image
  File? _image1, _image2, _image3, _image4;
  bool _isCameraEnabled = false;

  final ImagePicker picker = ImagePicker();

  Future<void> _getImage(int index) async {
    if (!_isCameraEnabled) return;

    var cameraStatus = await Permission.camera.request();
    var photosStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && photosStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          switch (index) {
            case 1: _image1 = File(pickedFile.path); break;
            case 2: _image2 = File(pickedFile.path); break;
            case 3: _image3 = File(pickedFile.path); break;
            case 4: _image4 = File(pickedFile.path); break; 
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
    // Dummy data readonly
    final String tiketTimbang = '"Tiket Timbang"';
    final String namaSupir = '"Nama Supir"';
    final String kodeKomoditi = '"Kode Komoditi"';
    final String namaKomoditi = '"Nama Komoditi"';
    final String kodeVendor = '"Kode Vendor"';
    final String namaVendor = '"Nama Vendor"';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah QC PK'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Plat Kendaraan", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.platKendaraan, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            _buildReadOnlyField('Tiket Timbang', tiketTimbang),
            _buildReadOnlyField('Supir', namaSupir),
            _buildReadOnlyField('Kode Komoditi', kodeKomoditi),
            _buildReadOnlyField('Nama Komoditi', namaKomoditi),
            _buildReadOnlyField('Kode Vendor', kodeVendor),
            _buildReadOnlyField('Nama Vendor', namaVendor),

            const SizedBox(height: 20),
            const Text("Input QC Data", style: TextStyle(fontWeight: FontWeight.bold)),

            Row(
              children: [
                Expanded(child: _buildInputField("FFA (%)", ffaCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _buildInputField("Moisture (%)", moistCtrl)),
              ],
            ),
            const SizedBox(height: 8),
            _buildInputField("Netto (kg)", nettoCtrl),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInputField("DOB (Ccr/Tin)", dobCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _buildInputField("WR (g/100g)", wrCtrl)),
              ],
            ),

            const SizedBox(height: 12),
            _buildInputField("Remarks", remarksCtrl, maxLines: 3),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data Adopted!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Adopt"),
            ),

            const SizedBox(height: 16),
            CheckboxListTile(
              value: _isCameraEnabled,
              activeColor: Colors.green,
              title: const Text('Ambil Gambar'),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) {
                setState(() {
                  _isCameraEnabled = val ?? false;
                  if (!_isCameraEnabled) {
                    _image1 = _image2 = _image3 = _image4 = null;
                  }
                });
              },
            ),
            const SizedBox(height: 12),

            // Layout kamera
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImagePickerBox(1, _image1),
                    _buildImagePickerBox(2, _image2),
                    _buildImagePickerBox(3, _image3),
                    _buildImagePickerBox(4, _image4),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),

            // Action buttons 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {},
                  child: const Text("Hold"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {},
                  child: const Text("Approve"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {},
                  child: const Text("Reject"),
                ),
              ],
            )
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(int index, File? imageFile) {
    final bool isEnabled = _isCameraEnabled;
    return GestureDetector(
      onTap: isEnabled ? () => _getImage(index) : null,
      child: Container(
        width: 180,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(6),
          color: isEnabled ? Colors.grey[100] : Colors.grey[400],
        ),
        child: imageFile == null
            ? Icon(Icons.camera_alt,
                size: 28, color: isEnabled ? Colors.black : Colors.black45)
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
      ),
    );
  }
} 