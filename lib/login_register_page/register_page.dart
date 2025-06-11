
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() => isLoading = true);
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:8000/api/user',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role': 'pengurus',
          'id_fakultas': 1,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      print('Register berhasil: ${response.data}');
      await loginAfterRegister(emailController.text, passwordController.text);
    } catch (e) {
      print('Register gagal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register gagal')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loginAfterRegister(String email, String password) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:8000/api/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final token = response.data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      print('Login otomatis berhasil. Token: $token');

      Navigator.pushReplacementNamed(context, '/beranda');
    } catch (e) {
      print('Login otomatis gagal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/logo_alfath.png'),
              const SizedBox(height: 40),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: registerUser,
                      child: const Text('Daftar'),
                    ),
              const SizedBox(height: 30),
              Image.asset('assets/google.png', height: 30),
            ],
          ),
        ),
      ),
    );
  }
}