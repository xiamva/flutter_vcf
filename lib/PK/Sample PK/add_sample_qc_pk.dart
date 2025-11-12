import 'package:flutter/material.dart';
import 'add_pk_data.dart';

class AddSampleQCPKPage extends StatefulWidget {
  final String userId;
  const AddSampleQCPKPage({super.key, required this.userId});

  @override
  State<AddSampleQCPKPage> createState() => _AddSampleQCCPOPageState();
}

class _AddSampleQCCPOPageState extends State<AddSampleQCPKPage> {
  String? selectedPlat;
  final List<String> platList = [
    // Data plat kendaraan dari database, sementara dummy
    'XX XXXX XXX',
    'YY YYYY YYY',
    'ZZ ZZZZ ZZZ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Sample QC'),
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
            const SizedBox(height: 8),
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
                  // Navigasi ke add_cpo_data.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPkData(platKendaraan: value),
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