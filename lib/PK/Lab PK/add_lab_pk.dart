import 'package:flutter/material.dart';
import 'input_lab_pk.dart';

class AddLabPKPage extends StatefulWidget {
  final String userId;
  const AddLabPKPage({super.key, required this.userId});

  @override
  State<AddLabPKPage> createState() => _AddLabPKPageState();
}

class _AddLabPKPageState extends State<AddLabPKPage> {
  String? selectedPlat;
  final List<String> platList = [
    // Dummy data plat kendaraan, bisa diambil dari API/database
    'XX 1234 XX',
    'YY 5678 YY',
    'ZZ 9999 ZZ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah QC PK'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silahkan Pilih Plat Kendaraan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Plat Kendaraan',
              ),
              value: selectedPlat,
              items: platList.map((plat) {
                return DropdownMenuItem(
                  value: plat,
                  child: Text(plat),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPlat = value;
                  });
                  // Navigasi ke input_lab_pk.dart 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputLabPKPage(
                        userId: widget.userId,
                        platKendaraan: value,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}