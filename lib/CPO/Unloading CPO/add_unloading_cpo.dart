import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_unloading_cpo.dart';

class AddUnloadingCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddUnloadingCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AddUnloadingCPOPage> createState() => _AddUnloadingCPOPageState();
}

class _AddUnloadingCPOPageState extends State<AddUnloadingCPOPage> {
  String? selectedPlat;

  late Future<UnloadingCPOResponse> futureVehicles =
      Future.value(UnloadingCPOResponse(success: true, message: "", data: []));

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
    final apiService =
        ApiService(AppConfig.createDio());

    setState(() {
      futureVehicles = apiService.getPosts("Bearer $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Unloading CPO'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),

      body: FutureBuilder<UnloadingCPOResponse>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data?.data ?? [];

          // ==========
          // Show ONLY vehicles with regist_status = "unloading"
          // ==========
          final readyVehicles = data.where((e) {
            final status = (e.regist_status ?? "").toLowerCase();
            return status == "unloading";
          }).toList();

          // Unique plat
          final uniquePlates =
              readyVehicles.map((e) => e.plate_number).toSet().toList();

          if (readyVehicles.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada kendaraan yang siap unloading.",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            );
          }

          // reset selectedPlat if not valid after refresh
          if (selectedPlat != null && !uniquePlates.contains(selectedPlat)) {
            selectedPlat = null;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silakan Pilih Plat Kendaraan yang Siap Unloading',
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
                    final item =
                        readyVehicles.firstWhere((e) => e.plate_number == plate);

                    return DropdownMenuItem(
                      value: plate,
                      child: Text("$plate (${item.wb_ticket_no})"),
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
                      "Lanjut ke Input Unloading",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: selectedPlat == null
                        ? null
                        : () async {
                            final kendaraan = readyVehicles.firstWhere(
                              (item) => item.plate_number == selectedPlat,
                            );

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InputUnloadingCPOPage(
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
