import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/manager/manager_check_ticket.dart';
import 'package:flutter_vcf/models/manager/manager_check_detail.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_tickets_response.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_detail_response.dart';

class SpTiketManagerPKPage extends StatefulWidget {
  final String userId;
  final String token;

  const SpTiketManagerPKPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<SpTiketManagerPKPage> createState() => _SpTiketManagerPKPageState();
}

class _SpTiketManagerPKPageState extends State<SpTiketManagerPKPage> {
  List<ManagerCheckTicket> tickets = [];
  bool isLoading = false;

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    fetchTickets();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString("jwt_token") ??
        prefs.getString("token") ??
        widget.token;
    return token;
  }

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      final res = await api.getManagerCheckTickets(
        "Bearer $token",
        "PK",
        stage: "sampling",
      );

      if (!mounted) return;
      setState(() {
        tickets = res.data ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal fetch data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Sampling PK"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchTickets),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada tiket sampling untuk di-check.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchTickets,
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (_, i) {
                  final ticket = tickets[i];
                  final isChecked = ticket.has_manager_check == true;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Already checked: ${ticket.latest_check_status ?? 'DONE'}",
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => _ManagerSamplingCheckInputPage(
                              token: widget.token,
                              ticket: ticket,
                              onComplete: () {
                                fetchTickets();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "WB: ${ticket.wb_ticket_no ?? '-'}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (isChecked)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          ticket.latest_check_status ??
                                              "Checked",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ticket.plate_number ?? "-",
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Driver: ${ticket.driver_name ?? '-'}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "Vendor: ${ticket.vendor_name ?? '-'}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// =============================================================================
// NESTED INPUT PAGE FOR MANAGER SAMPLING CHECK (PK)
// =============================================================================

class _ManagerSamplingCheckInputPage extends StatefulWidget {
  final String token;
  final ManagerCheckTicket ticket;
  final VoidCallback onComplete;

  const _ManagerSamplingCheckInputPage({
    required this.token,
    required this.ticket,
    required this.onComplete,
  });

  @override
  State<_ManagerSamplingCheckInputPage> createState() =>
      _ManagerSamplingCheckInputPageState();
}

class _ManagerSamplingCheckInputPageState
    extends State<_ManagerSamplingCheckInputPage> {
  ManagerCheckDetail? detail;
  bool isLoading = true;
  bool isSubmitting = false;

  final TextEditingController remarksCtrl = TextEditingController();
  File? _image1, _image2, _image3, _image4;
  final ImagePicker picker = ImagePicker();

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    _loadDetail();
  }

  @override
  void dispose() {
    remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    final registrationId = widget.ticket.registration_id;
    if (registrationId == null) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration ID is missing"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final res = await api.getManagerCheckTicketDetail(
        "Bearer ${widget.token}",
        registrationId,
        "sampling",
      );
      if (!mounted) return;
      setState(() {
        detail = res.data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load detail: $e")));
    }
  }

  Future<void> _getImage(int index) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission required")),
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        switch (index) {
          case 1:
            _image1 = File(picked.path);
            break;
          case 2:
            _image2 = File(picked.path);
            break;
          case 3:
            _image3 = File(picked.path);
            break;
          case 4:
            _image4 = File(picked.path);
            break;
        }
      });
    }
  }

  Future<void> _submit(String status) async {
    // Collect photos
    final photos = <String>[];
    for (final img in [_image1, _image2, _image3, _image4]) {
      if (img != null) {
        final bytes = await img.readAsBytes();
        photos.add(base64Encode(bytes));
      }
    }

    if (!mounted) return;

    // Validate: at least 1 photo required
    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("At least one photo is required"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await api.submitManagerSamplingCheck("Bearer ${widget.token}", {
        "process_id": widget.ticket.process_id,
        "check_status": status,
        "remarks": remarksCtrl.text,
        "photos": photos,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check submitted: $status"),
          backgroundColor: Colors.green,
        ),
      );
      widget.onComplete();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);

      if (e.response?.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This ticket has already been checked"),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Widget _photoBox(int i, File? img) {
    return GestureDetector(
      onTap: () => _getImage(i),
      child: Container(
        width: 70,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: img == null
            ? Icon(Icons.camera_alt, size: 24, color: Colors.black54)
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(img, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Sampling Check"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ticket Info",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          _readOnlyField(
                            "WB Ticket",
                            widget.ticket.wb_ticket_no ?? "-",
                          ),
                          _readOnlyField(
                            "Plate Number",
                            widget.ticket.plate_number ?? "-",
                          ),
                          _readOnlyField(
                            "Driver",
                            widget.ticket.driver_name ?? "-",
                          ),
                          _readOnlyField(
                            "Vendor",
                            widget.ticket.vendor_name ?? "-",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Operator Sampling Data Card (PK specific fields)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Operator Sampling Data",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          _readOnlyField(
                            "Counter (Resample)",
                            "${detail?.sampling_data?['counter'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Kernel Dirt",
                            "${detail?.sampling_data?['kernel_dirt'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Oil Content Estimate",
                            "${detail?.sampling_data?['oil_content_estimate'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Sampled By",
                            "${detail?.sampling_data?['sampled_by'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Sampled At",
                            "${detail?.sampling_data?['sampled_at'] ?? '-'}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Photo Capture Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Photos (min 1 required)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _photoBox(1, _image1),
                              _photoBox(2, _image2),
                              _photoBox(3, _image3),
                              _photoBox(4, _image4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Remarks Field
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Remarks",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          TextFormField(
                            controller: remarksCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Enter remarks (optional)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // APPROVE / REJECT Buttons
                  if (isSubmitting)
                    const Center(child: CircularProgressIndicator())
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _submit("REJECT"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "REJECT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _submit("APPROVE"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "APPROVE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
