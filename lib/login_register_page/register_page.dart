import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<dynamic> fakultasList = [];
  int? selectedFakultasId;
  bool isLoadingFakultas = true;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    fetchFakultas();
  }

  Future<void> fetchFakultas() async {
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/fakultas');
      if (response.statusCode == 200) {
        setState(() {
          fakultasList = response.data['data'];
          isLoadingFakultas = false;
          selectedFakultasId =
              fakultasList.isNotEmpty ? fakultasList[0]['id_fakultas'] : null;
        });
      }
    } catch (e) {
      print("Gagal fetch fakultas: $e");
    }
  }

  Future<void> register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedFakultasId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    setState(() => isRegistering = true);
    try {
      await Dio().post(
        'http://10.0.2.2:8000/api/register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'id_fakultas': selectedFakultasId,
          'role': 'pengurus',
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } on DioError catch (e) {
      print("Gagal register: ${e.response?.data}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendaftar: ${e.response?.data}")),
      );
    } catch (e) {
      print("Gagal register: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendaftar: $e")),
      );
    } finally {
      setState(() => isRegistering = false);
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
      backgroundColor: Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset('assets/logo_alfath.png', height: 100),
            SizedBox(height: 20),
            Text(
              "Daftar Akun",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: softDecoration,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedFakultasId,
                  isExpanded: true,
                  hint: Text("Pilih Fakultas"),
                  items:
                      fakultasList.map<DropdownMenuItem<int>>((fakultas) {
                        return DropdownMenuItem<int>(
                          value: fakultas['id_fakultas'],
                          child: Text(fakultas['nama_fakultas']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedFakultasId = value);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: softDecoration,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nama Lengkap',
                ),
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Login di sini",
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
              onTap: isRegistering ? null : register,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: softDecoration,
                child:
                    isRegistering
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30),
            Text("Atau daftar dengan", style: TextStyle(color: Colors.grey)),
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
