import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/manager/manager_check_detail.dart';
import 'package:flutter_vcf/models/manager/manager_check_ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LbTiketManagerPOMEPage extends StatefulWidget {
  final String userId;
  final String token;

  const LbTiketManagerPOMEPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<LbTiketManagerPOMEPage> createState() => _LbTiketManagerPOMEPageState();
}

class _LbTiketManagerPOMEPageState extends State<LbTiketManagerPOMEPage> {
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
    return prefs.getString("jwt_token") ??
        prefs.getString("token") ??
        widget.token;
  }

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      final res = await api.getManagerCheckTickets(
        "Bearer $token",
        "POME",
        stage: "lab",
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
        title: const Text("Manager Lab POME"),
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
                "Tidak ada tiket lab untuk di-check.",
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
                            builder: (_) => _ManagerLabCheckInputPage(
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
// NESTED INPUT PAGE FOR MANAGER LAB CHECK (POME - FFA & Moisture only)
// =============================================================================

class _ManagerLabCheckInputPage extends StatefulWidget {
  final String token;
  final ManagerCheckTicket ticket;
  final VoidCallback onComplete;

  const _ManagerLabCheckInputPage({
    required this.token,
    required this.ticket,
    required this.onComplete,
  });

  @override
  State<_ManagerLabCheckInputPage> createState() =>
      _ManagerLabCheckInputPageState();
}

class _ManagerLabCheckInputPageState extends State<_ManagerLabCheckInputPage> {
  ManagerCheckDetail? detail;
  bool isLoading = true;
  bool isSubmitting = false;

  // POME only has FFA and Moisture (not DOBI, IV)
  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService(AppConfig.createDio());
    _loadDetail();
  }

  @override
  void dispose() {
    ffaCtrl.dispose();
    moistCtrl.dispose();
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
        "lab",
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

  Future<void> _submit(String status) async {
    // Validate required fields (POME: FFA and Moisture only)
    if (ffaCtrl.text.isEmpty || moistCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("FFA and Moisture are required"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await api.submitManagerLabCheck("Bearer ${widget.token}", {
        "process_id": widget.ticket.process_id,
        "check_status": status,
        "remarks": remarksCtrl.text,
        "mgr_ffa": double.parse(ffaCtrl.text),
        "mgr_moisture": double.parse(moistCtrl.text),
        // POME does NOT have mgr_dobi or mgr_iv
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
    } on FormatException {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid number format"),
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

  Widget _numericField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Lab Check"),
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

                  // Operator Lab Data Card (POME: FFA & Moisture only)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Operator Lab Values",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          _readOnlyField(
                            "FFA",
                            "${detail?.lab_data?['ffa'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Moisture",
                            "${detail?.lab_data?['moisture'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Tested By",
                            "${detail?.lab_data?['tested_by'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "Tested At",
                            "${detail?.lab_data?['tested_at'] ?? '-'}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Manager Input Fields Card (POME: FFA & Moisture only)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Manager Lab Values",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          _numericField("Manager FFA", ffaCtrl),
                          _numericField("Manager Moisture", moistCtrl),
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
