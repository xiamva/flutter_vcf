import 'package:flutter/material.dart';
import 'sample_qc_pk.dart'; 
import '../../login.dart';

class HomePKPage extends StatefulWidget {
  final String userId;
  final String token;
  const HomePKPage({super.key, required this.userId, required this.token});

  @override
  State<HomePKPage> createState() => _HomePKPageState();
}

class _HomePKPageState extends State<HomePKPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Home VCF", 
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 5),
            DropdownButton<String>(
              dropdownColor: Colors.blue[100],
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              value: null,
              hint: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  if (newValue == "PK") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SampleQCPKPage(userId: widget.userId),
                      ),
                    );
                  }
                }
              },
              items: [
                // Header Sample QC (tidak bisa diklik)
                const DropdownMenuItem<String>(
                  enabled: false,
                  child: Row(
                    children: [
                      Text("Sample QC", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
                // Item PK (bisa diklik)
                const DropdownMenuItem<String>(
                  value: "PK",
                  child: Text("PK"),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu VCF",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hai, QC Sample",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Last Update : 2025-07-15 10:30:00",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // QC Sample Box
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black54),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.science, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "QC Sample PK",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInfoRow("Total Truk Masuk", " "),
                    _buildInfoRow("Truk Belum Ambil Sample", " "),
                    _buildInfoRow("Truk Sudah Ambil Sample", " "),
                    _buildInfoRow("Total Truk Keluar", "60"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk bikin row info
  static Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(title),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
