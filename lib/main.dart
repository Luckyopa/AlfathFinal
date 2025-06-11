import 'package:flutter/material.dart';
import 'package:alfath/login_register_page/login_page.dart';
import 'package:alfath/login_register_page/register_page.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'splash_screen.dart'; // <-- tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alfath Connect',
      initialRoute: '/', // mulai dari splash
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/beranda': (context) => const AdminPage(),
      },
    );
  }
}
