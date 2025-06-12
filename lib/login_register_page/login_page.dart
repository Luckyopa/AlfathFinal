import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:8000/api/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      print("Response: " + response.data.toString());
      final token = response.data['access_token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt(
          'id_user',
          response.data['user']['id_user'],
        ); // simpan id

        Navigator.pushReplacementNamed(context, '/beranda');
      } else {
        throw Exception("Token tidak ditemukan di respons.");
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final softDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
        BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Image.asset('assets/logo_alfath.png', height: 100),
            SizedBox(height: 20),
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Login to your account",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30),

            Container(
              decoration: softDecoration,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 16),

            Container(
              decoration: softDecoration,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Daftar di sini",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            InkWell(
              onTap: isLoading ? null : loginUser,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: softDecoration,
                child:
                    isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),

            SizedBox(height: 30),
            Text("Atau login dengan", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialLoginIcon('assets/google.png'),
                _socialLoginIcon('assets/facebook.png'),
                _socialLoginIcon('assets/twitter.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginIcon(String assetPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
        ],
      ),
      child: Image.asset(assetPath, width: 24),
    );
  }
}
