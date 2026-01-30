import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_response.dart';
import 'package:flutter_vcf/models/pk/unloading_pk_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_unloading_pk.dart';

class AddUnloadingPKPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddUnloadingPKPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AddUnloadingPKPage> createState() => _AddUnloadingPKPageState();
}

class _AddUnloadingPKPageState extends State<AddUnloadingPKPage> {
  String? selectedPlat;

  late Future<UnloadingPkResponse> futureVehicles = Future.value(
    UnloadingPkResponse(success: true, message: "", data: [], total: 0),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token") ?? widget.token;
  }

  void _loadData() async {
    final token = await _getToken();
    final apiService = ApiService(AppConfig.createDio());

    setState(() {
      futureVehicles = apiService.getUnloadingPk("Bearer $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Unloading PK'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),

      body: FutureBuilder<UnloadingPkResponse>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log("${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data?.data ?? [];

          final readyVehicles = data.where((e) {
            return (e.registStatus ?? "").toLowerCase() == "unloading";
          }).toList();

          final uniquePlates = readyVehicles
              .map((e) => e.plateNumber)
              .toSet()
              .toList();

          if (readyVehicles.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada kendaraan yang siap unloading.",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            );
          }

          // reset value jika plat tidak valid setelah refresh
          if (selectedPlat != null && !uniquePlates.contains(selectedPlat)) {
            selectedPlat = null;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silakan Pilih Plat Kendaraan yang Siap Unloading PK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Plat Kendaraan',
                  ),
                  value: selectedPlat,
                  items: uniquePlates.map((plate) {
                    final item = readyVehicles.firstWhere(
                      (e) => e.plateNumber == plate,
                    );

                    return DropdownMenuItem(
                      value: plate,
                      child: Text("$plate (${item.wbTicketNo})"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPlat = value);
                  },
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    label: const Text(
                      "Lanjut ke Input Unloading PK",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: selectedPlat == null
                        ? null
                        : () async {
                            final kendaraan = readyVehicles.firstWhere(
                              (item) => item.plateNumber == selectedPlat,
                            );

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InputUnloadingPKPage(
                                  model: kendaraan,
                                  token: widget.token,
                                ),
                              ),
                            );

                            if (result != null) {
                              Navigator.pop(context, result);
                            }
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
