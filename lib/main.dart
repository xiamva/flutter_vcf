import 'package:flutter/material.dart';
import 'login.dart'; 
void main() {
  runApp(const VCFApp());
}

class VCFApp extends StatelessWidget {
  const VCFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Card Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(), // langsung arahkan ke login.dart
    );
  }
}
