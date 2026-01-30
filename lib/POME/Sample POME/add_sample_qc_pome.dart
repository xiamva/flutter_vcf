import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/pome/qc_sampling_pome_vehicle.dart';
import 'add_pome_data.dart';

class AddSampleQCPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddSampleQCPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AddSampleQCPOMEPage> createState() => _AddSampleQCPOMEPageState();
}

class _AddSampleQCPOMEPageState extends State<AddSampleQCPOMEPage> {

  String? selectedPlat;
  List<QcSamplingPomeVehicle> platList = [];
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
    return prefs.getString("jwt_token") ?? widget.token;
  }

  Future<void> fetchVehiclePlates() async {
    setState(() => isLoading = true);

    try {
      final token = await _getToken();
      final res = await api.getQcSamplingPomeVehicles("Bearer $token");

      final vehicles = (res.data ?? [])
          .where((v) =>
              v.registStatus?.toLowerCase() == "qc_sampling" &&
              (v.hasSamplingData == false))
          .toList();

      if (vehicles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak ada kendaraan yang siap diambil sample."),
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
        SnackBar(
          content: Text("Gagal ambil data kendaraan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openAddPOMEPage(QcSamplingPomeVehicle v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPOMEDataPage(
          userId: widget.userId,
          token: widget.token,
          registrationId: v.registrationId ?? "",
          platKendaraan: v.plateNumber ?? "",
          tiketNo: v.wbTicketNo ?? "",
          driver: v.driverName ?? "",
          commodityCode: v.commodityCode ?? "",
          commodityName: v.commodityName ?? "",
          vendorCode: v.vendorCode ?? "",
          vendorName: v.vendorName ?? "",
        ),
      ),
    );

    if (result != null) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Sample QC POME"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchVehiclePlates)
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : platList.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada kendaraan untuk sampling",
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Plat Kendaraan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Plat Kendaraan",
                        ),
                        value: selectedPlat,
                        items: platList.map((v) {
                          return DropdownMenuItem<String>(
                            value: v.plateNumber,
                            child: Text("${v.plateNumber} (${v.wbTicketNo})"),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedPlat = value),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward, color: Colors.white),
                          label: const Text(
                            "Lanjut ke Input Sample",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: selectedPlat == null
                              ? null
                              : () {
                                  final v = platList.firstWhere(
                                    (item) => item.plateNumber == selectedPlat,
                                  );
                                  _openAddPOMEPage(v);
                                },
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
