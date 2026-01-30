import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vcf/PK/Lab%20PK/home_lab_pk.dart';
import 'package:flutter_vcf/PK/Unloading%20PK/home_unloading_pk.dart';
import 'package:flutter_vcf/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CPO/Lab CPO/home_lab_cpo.dart';
import 'CPO/Sample CPO/home_cpo.dart';
import 'CPO/Unloading CPO/home_unloading_cpo.dart';
import 'Manager/CPO/home_manager.dart';
import 'PK/Sample PK/home_pk.dart';
import 'POME/Lab POME/home_lab_pome.dart';
import 'POME/Sample POME/home_pome.dart';
import 'POME/Unloading POME/home_unloading_pome.dart';

void main() {
  runApp(const VCFApp());
}
// void main (){
//   runApp(const vcfApp()
//   );
// }

class VCFApp extends StatelessWidget {
  const VCFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Card Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  /// LOGIN FUNCTION DENGAN JWT TOKEN
  Future<void> login() async {
    String username = userIdController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID dan Password wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    var url = Uri.parse('${AppConfig.apiBaseUrl}login');

    // Log request details
    print('🔵 [LOGIN] Request URL: $url');
    print('🔵 [LOGIN] API Base URL: ${AppConfig.apiBaseUrl}');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      setState(() => isLoading = false);

      // Log response details
      print('🟢 [LOGIN] Response Status: ${response.statusCode}');
      print('🟢 [LOGIN] Response Headers: ${response.headers}');
      print('🟢 [LOGIN] Response Body Length: ${response.body.length}');
      print(
        '🟢 [LOGIN] Response Body (first 200 chars): ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
      );
      print('🟢 [LOGIN] Content-Type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        // Validate content-type before parsing
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          print(
            '❌ [LOGIN] ERROR: Response is not JSON! Content-Type: $contentType',
          );
          print('❌ [LOGIN] Full Response Body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Server returned non-JSON response. Check logs for details.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
          return;
        }

        // Validate response body is not empty
        if (response.body.isEmpty || response.body.trim().isEmpty) {
          print('❌ [LOGIN] ERROR: Response body is empty!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Server returned empty response'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }

        var data;
        try {
          data = json.decode(response.body);
          print('✅ [LOGIN] JSON parsed successfully');
        } catch (e) {
          print('❌ [LOGIN] JSON Parse Error: $e');
          print('❌ [LOGIN] Response Body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid JSON response from server. Check logs.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
          return;
        }

        if (data['success'] == true && data['data'] != null) {
          // Get raw token (without Bearer prefix)
          String token = data['data']['token'];

          // Store raw token - "Bearer " prefix is added when making API calls
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Extract roles from response
          List<String> roles = [];
          if (data['data']['user'] != null &&
              data['data']['user']['roles'] != null) {
            roles = List<String>.from(data['data']['user']['roles']);
          }

          // Route based on user roles (not username)
          _navigateByRole(roles, username, token);
        } else {
          // Extract error message from response (matching other screens pattern)
          String errorMessage =
              data['message'] ??
              data['error'] ??
              "User ID atau Password salah!";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        // Log error response
        print('🔴 [LOGIN] Error Status: ${response.statusCode}');
        print('🔴 [LOGIN] Error Headers: ${response.headers}');
        print('🔴 [LOGIN] Error Body: ${response.body}');

        // Try to extract error message from response body (matching other screens pattern)
        String errorMessage = "User ID atau Password salah!";
        try {
          // Check if response is JSON
          final contentType = response.headers['content-type'] ?? '';
          if (contentType.contains('application/json') &&
              response.body.isNotEmpty) {
            var errorData = json.decode(response.body);
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? errorMessage;
            print('🔴 [LOGIN] Parsed error message: $errorMessage');
          } else {
            print(
              '🔴 [LOGIN] Non-JSON error response. Content-Type: $contentType',
            );
            // If response is HTML or plain text, show generic message
            if (response.statusCode == 404) {
              errorMessage = "Endpoint tidak ditemukan. Periksa URL API.";
            } else if (response.statusCode == 500) {
              errorMessage = "Server error. Periksa log backend.";
            }
          }
        } catch (e) {
          print('🔴 [LOGIN] Error parsing error response: $e');
          // If parsing fails, use status code based message
          if (response.statusCode == 401) {
            errorMessage = "User ID atau Password salah!";
          } else if (response.statusCode == 422) {
            errorMessage = "Data tidak valid";
          } else if (response.statusCode == 404) {
            errorMessage = "Endpoint tidak ditemukan. Periksa konfigurasi API.";
          } else if (response.statusCode >= 500) {
            errorMessage = "Server error. Silakan coba lagi nanti.";
          } else {
            errorMessage = "Terjadi kesalahan (${response.statusCode})";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e, stackTrace) {
      setState(() => isLoading = false);
      print('❌ [LOGIN] Exception caught: $e');
      print('❌ [LOGIN] Stack trace: $stackTrace');

      String errorMessage = "Gagal koneksi ke server";
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
        print('❌ [LOGIN] Network error: Cannot reach server');
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = "Waktu koneksi habis. Silakan coba lagi.";
        print('❌ [LOGIN] Timeout error');
      } else if (e.toString().contains('FormatException') ||
          e.toString().contains('unexpected character')) {
        errorMessage = "Format response tidak valid. Periksa log untuk detail.";
        print('❌ [LOGIN] Format error - likely non-JSON response');
      } else {
        errorMessage = "Error: ${e.toString()}";
        print('❌ [LOGIN] Unknown error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Navigate to appropriate screen based on user roles
  void _navigateByRole(List<String> roles, String username, String token) {
    Widget? destination;

    // Priority: manajer > sample > lab > unloading
    if (roles.contains('manajer')) {
      destination = const ManagerHomeSwipe();
    }
    // CPO roles
    else if (roles.contains('sample_operator_cpo')) {
      destination = HomeCPOPage(userId: username, token: token);
    } else if (roles.contains('lab_operator_cpo')) {
      destination = HomeLabCPOPage(userId: username, token: token);
    } else if (roles.contains('unloading_operator_cpo')) {
      destination = HomeUnloadingCPOPage(userId: username, token: token);
    }
    // PK roles
    else if (roles.contains('sample_operator_pk')) {
      destination = HomePKPage(userId: username, token: token);
    } else if (roles.contains('lab_operator_pk')) {
      destination = HomeLabPKPage(userId: username, token: token);
    } else if (roles.contains('unloading_operator_pk')) {
      destination = HomeUnloadingPKPage(userId: username, token: token);
    }
    // POME roles
    else if (roles.contains('sample_operator_pome')) {
      destination = HomePOMEPage(userId: username, token: token);
    } else if (roles.contains('lab_operator_pome')) {
      destination = HomeLabPOMEPage(userId: username, token: token);
    } else if (roles.contains('unloading_operator_pome')) {
      destination = HomeUnloadingPOMEPage(userId: username, token: token);
    }

    if (destination != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Role tidak dikenali: ${roles.join(', ')}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset('assets/header.jpg', fit: BoxFit.cover),
            ),

            const SizedBox(height: 20),

            // Logo
            Image.asset('assets/logo.png', width: 100, height: 100),

            const SizedBox(height: 15),

            // Title
            const Text(
              "Vehicle Card Form",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "PT. Energi Unggul Persada\nTanjung Pura",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // Form User ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Form Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Login", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 40),

            // Footer
            const Text(
              "© KPN Corp 2025",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
