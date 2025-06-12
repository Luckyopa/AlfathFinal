import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
 // ✅ pakai key 'token'

    await Future.delayed(const Duration(seconds: 2)); // loading animasi

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/beranda');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_alfath.png', height: 120),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text("Memuat aplikasi...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
