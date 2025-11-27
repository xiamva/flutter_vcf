import 'package:flutter/material.dart';
import 'package:flutter_vcf/PK/Lab%20PK/home_lab_pk.dart';
import 'package:flutter_vcf/PK/Unloading%20PK/home_unloading_pk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'CPO/Sample CPO/home_cpo.dart';
import 'PK/Sample PK/home_pk.dart';
import 'POME/Sample POME/home_pome.dart';
import 'CPO/Lab CPO/home_lab_cpo.dart';
import 'CPO/Unloading CPO/home_unloading_cpo.dart';
import 'POME/Lab POME/home_lab_pome.dart';
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

  String message = '';
  bool isLoading = false;

  /// LOGIN FUNCTION DENGAN JWT TOKEN
  Future<void> login() async {
    String username = userIdController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => message = "User ID dan Password wajib diisi!");
      return;
    }

    setState(() => isLoading = true);

    // IP backend Laravel 
    var url = Uri.parse('http://172.30.64.207:8000/api/login');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      print(response);

        setState(() => isLoading = false);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        if (data['success'] == true && data['data'] != null) {
          // Ambil token dari backend
          String token = data['data']['token'];

          // Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          setState(() {
            message = "Login berhasil! Selamat datang $username";
          });

          // Kirim token ke halaman berikutnya jika diperlukan
          if (username == "sample_cpo") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeCPOPage(userId: username, token: token),
              ),
            ); 
          } else if (username == "lab_cpo") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLabCPOPage(userId: username, token: token),
              ),
            );
          } else if (username == "unloading_cpo") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUnloadingCPOPage(userId: username, token: token),
              ),
            );
          } else if (username == "sample_pk") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePKPage(userId: username, token: token),
              ),
            );
          } else if (username == "lab_pk") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLabPKPage(userId: username, token: token),
              ),
            );
           } else if (username == "unloading_pk") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUnloadingPKPage(userId: username, token: token),
              ),
            );
          } else if (username == "sample_pome") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePOMEPage(userId: username, token: token),
              ),
            );
          } else if (username == "lab_pome") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLabPOMEPage(userId: username, token: token),
              ),
            );
            } else if (username == "unloading_pome") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUnloadingPOMEPage(userId: username, token: token),
              ),
            );
          // } else if (username == "LAB PK KPN") {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => HomeLabPKPage(userId: username, token: token),
          //     ),
          //   );
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Halaman untuk $username belum dibuat")),
          //   );
          }
        } else {
          setState(() {
            message = "User ID atau Password salah!";
          });
        }
      } else {
        setState(() {
          message = "User ID atau Password salah! ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Gagal koneksi ke server: $e";
      });
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
              child: Image.asset(
                'assets/header.jpg',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Logo
            Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),

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
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
                  : const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
            ),

            const SizedBox(height: 20),

            // Pesan error / sukses
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: message.contains("berhasil") ? Colors.green : Colors.red,
              ),
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


