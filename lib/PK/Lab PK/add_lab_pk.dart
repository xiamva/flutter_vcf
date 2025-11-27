import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';

import 'package:flutter_vcf/models/pk/response/qc_lab_pk_vehicles_response.dart';
import 'input_lab_pk.dart';

class AddLabPKPage extends StatefulWidget {
  final String userId;

  const AddLabPKPage({
    super.key,
    required this.userId,
  });

  @override
  State<AddLabPKPage> createState() => _AddLabPKPageState();
}

class _AddLabPKPageState extends State<AddLabPKPage> {
  String? selectedPlat;
  List<QcLabPkVehicle> platList = [];
  bool isLoading = true;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(Dio());
    fetchVehiclePlates();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchVehiclePlates() async {
    setState(() => isLoading = true);

    try {
      final token = await _getToken();
      final res = await api.getQcLabPkVehicles("Bearer $token");

      // Filter: hanya PK yang siap QC Lab
      final vehicles = (res.data ?? []).where((v) {
        final regist = (v.registStatus ?? "").toLowerCase();
        final lab = v.labStatus;

        return regist == "qc_lab" && (lab == null || lab.isEmpty);
      }).toList();

      if (vehicles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak ada kendaraan yang siap diuji lab."),
            backgroundColor: Colors.orange,
          ),
        );
      }

      setState(() {
        platList = vehicles;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal fetch data: $e")),
      );
    }
  }

  Future<void> _openInputPage(QcLabPkVehicle v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputLabPKPage(model: v),
      ),
    );

    if (result != null) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah QC Lab PK'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchVehiclePlates,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : platList.isEmpty
              ? const Center(child: Text("Tidak ada kendaraan."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih Plat Kendaraan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // DROPDOWN PILIH PLAT
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Plat Kendaraan',
                        ),
                        value: selectedPlat,
                        items: platList.map((v) {
                          return DropdownMenuItem<String>(
                            value: v.plateNumber,
                            child: Text(
                                "${v.plateNumber} (${v.wbTicketNo ?? '-'})"),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedPlat = value),
                      ),

                      const SizedBox(height: 20),

                      // BUTTON MULAI
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Mulai QC Lab"),
                          onPressed: selectedPlat == null
                              ? null
                              : () {
                                  final selectedVehicle = platList.firstWhere(
                                      (x) => x.plateNumber == selectedPlat);

                                  _openInputPage(selectedVehicle);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
