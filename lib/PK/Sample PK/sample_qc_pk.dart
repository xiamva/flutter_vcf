import 'package:flutter/material.dart';
import 'add_sample_qc_pk.dart';

class SampleQCPKPage extends StatelessWidget {
  final String userId;
  const SampleQCPKPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dummy data tiket
    final List<Map<String, String>> tickets = [
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX", "status": "Done"},
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX", "status": "Re-Sampling"},
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX", "status": "Done"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard QC POME"),
        backgroundColor: Colors.blue,
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final item = tickets[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '"${item["label"]}"',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item["number"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        color: item["status"] == "Done"
                            ? Colors.green[100]
                            : const Color.fromARGB(205, 255, 0, 0),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black54),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item["status"]!,
                        style: TextStyle(
                          color: item["status"] == "Done"
                              ? Colors.green
                              : const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          height: 1.1, // jarak antarbaris biar rapi
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // bisa dua baris
                        overflow: TextOverflow.visible,
                        softWrap: true, // aktifkan line break
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSampleQCPKPage(userId: userId),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0), size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
