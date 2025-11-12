import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_unloading_pome.dart';

class AddUnloadingPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddUnloadingPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AddUnloadingPOMEPage> createState() => _AddUnloadingPOMEPageState();
}

class _AddUnloadingPOMEPageState extends State<AddUnloadingPOMEPage> {
  String? selectedPlat;

  late Future<UnloadingPOMEResponse> futureVehicles =
      Future.value(UnloadingPOMEResponse(success: true, message: "", data: []));

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
    final apiService = ApiService(Dio(BaseOptions(contentType: "application/json")));

    setState(() {
      futureVehicles = apiService.getUnloadingPomeData("Bearer $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Unloading POME'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),

      body: FutureBuilder<UnloadingPOMEResponse>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data?.data ?? [];

          // Filter kendaraan dengan status "unloading"
          final readyVehicles = data.where((e) =>
              (e.regist_status ?? "").toLowerCase() == "unloading"
          ).toList();

          // Ambil plat 
          final uniquePlates = readyVehicles
              .map((e) => e.plate_number)
              .toSet()
              .toList();

          // Reset dropdown kalau plat hilang
          if (selectedPlat != null && !uniquePlates.contains(selectedPlat)) {
            selectedPlat = null;
          }

          if (readyVehicles.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada kendaraan yang siap unloading POME.",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silakan Pilih Plat Kendaraan yang Siap Unloading POME',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Plat Kendaraan',
                  ),
                  value: selectedPlat,
                  items: uniquePlates.map((plate) {
                    final v = readyVehicles.firstWhere((e) => e.plate_number == plate);
                    return DropdownMenuItem(
                      value: plate,
                      child: Text("$plate (${v.wb_ticket_no})"),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedPlat = value),
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      "Lanjut ke Input Unloading",
                      style: TextStyle(color: Colors.white),
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
                                builder: (_) => InputUnloadingPOMEPage(
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
