import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/response/qc_sampling_cpo_vehicles_response.dart';
import 'package:flutter_vcf/models/qc_sampling_vehicle.dart'; 
import 'add_cpo_data.dart';

class AddSampleQCCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const AddSampleQCCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });
  
  @override
  State<AddSampleQCCPOPage> createState() => _AddSampleQCCPOPageState();
}

class _AddSampleQCCPOPageState extends State<AddSampleQCCPOPage> {
  String? selectedPlat;
  List<QcSamplingCpoVehicle> platList = []; 
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
      final res = await api.getQcSamplingCpoVehicles("Bearer $token");

      final vehicles = (res.data ?? [])
          .where((v) =>
              v.regist_status?.toLowerCase() == "qc_sampling" &&
              (v.has_sampling_data == false))
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
          content: Text("Gagal mengambil data kendaraan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openAddCPOPage(QcSamplingCpoVehicle v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCPODataPage(
          userId: widget.userId,
          token: widget.token,
          registrationId: v.registration_id ?? "",
          platKendaraan: v.plate_number ?? "",
          tiketNo: v.wb_ticket_no ?? "",
          driver: v.driver_name ?? "",
          commodityCode: v.commodity_code ?? "",
          commodityName: v.commodity_name ?? "",
          vendorCode: v.vendor_code ?? "",
          vendorName: v.vendor_name ?? "",
        ),
      ),
    );

    if (result != null) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Sample QC CPO'),
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
                        onChanged: (value) {
                          setState(() => selectedPlat = value);
                        },
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
                                      (item) => item.plate_number == selectedPlat);
                                  _openAddCPOPage(v);
                                },
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
