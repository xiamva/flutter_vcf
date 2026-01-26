import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';

import 'package:flutter_vcf/models/qc_lab_cpo_vehicle.dart';
import 'input_lab_cpo.dart';

class AddLabCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddLabCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AddLabCPOPage> createState() => _AddLabCPOPageState();
}

class _AddLabCPOPageState extends State<AddLabCPOPage> {
  String? selectedPlat;
  List<QcLabCpoVehicle> platList = [];
  bool isLoading = true;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    fetchVehiclePlates();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? widget.token;
  }

  Future<void> fetchVehiclePlates() async {
    setState(() => isLoading = true);

    try {
      final token = await _getToken();
      final res = await api.getQcLabCpoVehicles("Bearer $token");

      // ambil hanya yg qc_lab dan lab_status masih null
      final vehicles = (res.data ?? [])
          .where((v) =>
              v.regist_status?.toLowerCase() == "qc_lab" &&
              (v.lab_status == null || v.lab_status!.isEmpty))
          .toList();

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal fetch data: $e")));
    }
  }

  Future<void> _openInputPage(QcLabCpoVehicle v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputLabCPOPage(
          token: widget.token,
          model: v, // kirim model kendaraan
        ),
      ),
    );

    if (result != null) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah QC Lab CPO'),
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

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Plat Kendaraan',
                        ),
                        value: selectedPlat,
                        items: platList.map((v) {
                          return DropdownMenuItem<String>(
                            value: v.plate_number,
                            child: Text("${v.plate_number} (${v.wb_ticket_no})"),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedPlat = value),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Mulai QC Lab"),
                          onPressed: selectedPlat == null
                              ? null
                              : () {
                                  final v = platList.firstWhere(
                                      (x) => x.plate_number == selectedPlat);
                                  _openInputPage(v);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
