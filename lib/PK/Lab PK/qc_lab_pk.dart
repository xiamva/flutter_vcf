import 'package:flutter/material.dart';
import 'add_lab_pk.dart';

class QCLabPKPage extends StatelessWidget {
  final String userId;

  const QCLabPKPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // contoh data dummy
    final List<Map<String, String>> tickets = [
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX"},
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX"},
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX"},
      {"label": "Nomor Tiket Timbang", "number": "XX XXXX XXX"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard QC PK"),
        backgroundColor: Colors.blue[200],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final item = tickets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: Colors.black26),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Label + Nomor
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\"${item["label"]}\"",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["number"]!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  // Tombol aksi sesuai index
                  if (index == 0)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Approved: ${item["number"]}")),
                        );
                      },
                      child: const Text("Approve"),
                    ),
                  if (index == 1)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Hold: ${item["number"]}")),
                        );
                      },
                      child: const Text("Hold"),
                    ),
                  if (index == 2)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Rejected: ${item["number"]}")),
                        );
                      },
                      child: const Text("Reject"),
                    ),
                  if (index == 3)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Re-Sampling: ${item["number"]}")),
                        );
                      },
                      child: const Text("Re-Sampling"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLabPKPage(userId: userId),
            ),
          );
        },
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
} 