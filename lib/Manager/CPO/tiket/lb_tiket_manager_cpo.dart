import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vcf/api_service.dart';
import 'package:flutter_vcf/config.dart';
import 'package:flutter_vcf/models/manager/manager_check_detail.dart';
import 'package:flutter_vcf/models/manager/manager_check_ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LbTiketManagerCPOPage extends StatefulWidget {
  final String userId;
  final String token;

  const LbTiketManagerCPOPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<LbTiketManagerCPOPage> createState() => _LbTiketManagerCPOPageState();
}

class _LbTiketManagerCPOPageState extends State<LbTiketManagerCPOPage> {
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

  String _stageLabel(String? stage) {
    switch (stage) {
      case 'sampling':
        return 'Sampling';
      case 'lab':
        return 'Lab';
      case 'unloading':
        return 'Unloading';
      default:
        return stage ?? '-';
    }
  }

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);
    try {
      final token = await getToken();
      final res = await api.getManagerCheckTickets(
        "Bearer $token",
        "CPO",
        stage: "lab",
      );

      setState(() {
        tickets = res.data ?? [];
        isLoading = false;
      });
    } catch (e) {
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
        title: const Text("Manager Lab CPO"),
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
                            // Previous stage checks history
                            if (ticket.previous_checks != null &&
                                ticket.previous_checks!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: ticket.previous_checks!.map((check) {
                                  final isApproved =
                                      check.check_status == "APPROVE";
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isApproved
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isApproved
                                            ? Colors.green.shade400
                                            : Colors.red.shade400,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isApproved
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          size: 14,
                                          color: isApproved
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${_stageLabel(check.stage)}: ${check.check_status}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isApproved
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
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
// NESTED INPUT PAGE FOR MANAGER LAB CHECK (CPO)
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

  final TextEditingController ffaCtrl = TextEditingController();
  final TextEditingController moistCtrl = TextEditingController();
  final TextEditingController dobiCtrl = TextEditingController();
  final TextEditingController ivCtrl = TextEditingController();
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
    dobiCtrl.dispose();
    ivCtrl.dispose();
    remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    try {
      final res = await api.getManagerCheckTicketDetail(
        "Bearer ${widget.token}",
        widget.ticket.registration_id!,
        "lab",
      );
      setState(() {
        detail = res.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load detail: $e")));
    }
  }

  Future<void> _submit(String status) async {
    debugPrint('[Manager Lab Check] Starting submission');
    debugPrint('[Manager Lab Check] Status: $status');
    debugPrint('[Manager Lab Check] Process ID: ${widget.ticket.process_id}');
    debugPrint('[Manager Lab Check] Registration ID: ${widget.ticket.registration_id}');

    // Validate required fields
    if (ffaCtrl.text.isEmpty ||
        moistCtrl.text.isEmpty ||
        dobiCtrl.text.isEmpty ||
        ivCtrl.text.isEmpty) {
      debugPrint('[Manager Lab Check] Validation failed: Empty required fields');
      debugPrint('[Manager Lab Check] FFA: ${ffaCtrl.text.isEmpty ? "EMPTY" : ffaCtrl.text}');
      debugPrint('[Manager Lab Check] Moisture: ${moistCtrl.text.isEmpty ? "EMPTY" : moistCtrl.text}');
      debugPrint('[Manager Lab Check] DOBI: ${dobiCtrl.text.isEmpty ? "EMPTY" : dobiCtrl.text}');
      debugPrint('[Manager Lab Check] IV: ${ivCtrl.text.isEmpty ? "EMPTY" : ivCtrl.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All lab fields are required"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Parse and validate values
    double mgrFfa, mgrMoisture, mgrDobi, mgrIv;
    try {
      mgrFfa = double.parse(ffaCtrl.text);
      mgrMoisture = double.parse(moistCtrl.text);
      mgrDobi = double.parse(dobiCtrl.text);
      mgrIv = double.parse(ivCtrl.text);
    } on FormatException catch (e) {
      debugPrint('[Manager Lab Check] FormatException: Invalid number format');
      debugPrint('[Manager Lab Check] Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid number format"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate ranges (matching operator validation)
    if (mgrFfa < 0 || mgrFfa > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("FFA value must be between 0 and 100"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (mgrMoisture < 0 || mgrMoisture > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Moisture value must be between 0 and 100"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (mgrDobi < 0 || mgrDobi > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("DOBI value must be between 0 and 10"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (mgrIv < 0 || mgrIv > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("IV value must be between 0 and 1000"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      debugPrint('[Manager Lab Check] Parsed values:');
      debugPrint('[Manager Lab Check]   mgr_ffa: $mgrFfa');
      debugPrint('[Manager Lab Check]   mgr_moisture: $mgrMoisture');
      debugPrint('[Manager Lab Check]   mgr_dobi: $mgrDobi');
      debugPrint('[Manager Lab Check]   mgr_iv: $mgrIv');
      debugPrint('[Manager Lab Check]   remarks: ${remarksCtrl.text}');

      final requestData = {
        "process_id": widget.ticket.process_id,
        "check_status": status,
        "remarks": remarksCtrl.text,
        "mgr_ffa": mgrFfa,
        "mgr_moisture": mgrMoisture,
        "mgr_dobi": mgrDobi,
        "mgr_iv": mgrIv,
      };

      debugPrint('[Manager Lab Check] Request payload: $requestData');
      debugPrint('[Manager Lab Check] Sending API request...');

      await api.submitManagerLabCheck("Bearer ${widget.token}", requestData);

      debugPrint('[Manager Lab Check] API request successful');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check submitted: $status"),
          backgroundColor: Colors.green,
        ),
      );
      widget.onComplete();
    } on DioException catch (e) {
      setState(() => isSubmitting = false);

      debugPrint('[Manager Lab Check] DioException occurred');
      debugPrint('[Manager Lab Check] Error type: ${e.type}');
      debugPrint('[Manager Lab Check] Error message: ${e.message}');
      debugPrint('[Manager Lab Check] Status code: ${e.response?.statusCode}');
      debugPrint('[Manager Lab Check] Response data: ${e.response?.data}');
      debugPrint('[Manager Lab Check] Request options: ${e.requestOptions.uri}');
      debugPrint('[Manager Lab Check] Request data: ${e.requestOptions.data}');

      if (e.response?.statusCode == 409) {
        debugPrint('[Manager Lab Check] 409 Conflict: Ticket already checked');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This ticket has already been checked"),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context);
        return;
      }

      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      debugPrint('[Manager Lab Check] Showing error to user: $errorMessage');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $errorMessage"),
          backgroundColor: Colors.red,
        ),
      );
    } on FormatException catch (e) {
      setState(() => isSubmitting = false);
      debugPrint('[Manager Lab Check] FormatException: Invalid number format');
      debugPrint('[Manager Lab Check] Error: $e');
      debugPrint('[Manager Lab Check] FFA text: "${ffaCtrl.text}"');
      debugPrint('[Manager Lab Check] Moisture text: "${moistCtrl.text}"');
      debugPrint('[Manager Lab Check] DOBI text: "${dobiCtrl.text}"');
      debugPrint('[Manager Lab Check] IV text: "${ivCtrl.text}"');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid number format"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e, stackTrace) {
      setState(() => isSubmitting = false);
      debugPrint('[Manager Lab Check] Unexpected exception: $e');
      debugPrint('[Manager Lab Check] Stack trace: $stackTrace');
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

                  // Operator Lab Data Card
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
                            "DOBI",
                            "${detail?.lab_data?['dobi'] ?? '-'}",
                          ),
                          _readOnlyField(
                            "IV",
                            "${detail?.lab_data?['iv'] ?? '-'}",
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

                  // Manager Input Fields Card
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
                          _numericField("Manager DOBI", dobiCtrl),
                          _numericField("Manager IV", ivCtrl),
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
