import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:alfath/login_register_page/login_page.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'package:alfath/dokumen_page/dokumen.dart';
import 'package:alfath/kegiatan_page/kegiatan.dart';
import 'package:alfath/dokumentasi_page/dokumentasi.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('id_user');

    if (token != null && userId != null) {
      try {
        final dio = Dio();
        final response = await dio.get(
          'http://10.0.2.2:8000/api/user/$userId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );

        final data = response.data['data'];
        setState(() {
          userName = data['name'];
        });
      } catch (e) {
        print("Gagal mengambil user by ID: $e");
        setState(() {
          userName = "Gagal ambil data";
        });
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('id_user');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profil",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Kelola akun Anda",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: Offset(-4, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    userName ?? "Memuat...",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout,color: Colors.white,),
                      label: const Text("Logout",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 250),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              switch (index) {
                case 0:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPage()));
                  break;
                case 1:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DokumenPage()));
                  break;
                case 2:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KegiatanPage()));
                  break;
                case 3:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DokumentasiPage()));
                  break;
                case 4:
                  break;
              }
            },
            selectedItemColor: Colors.red.shade700,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: "Dokumen"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Kalender"),
              BottomNavigationBarItem(icon: Icon(Icons.image), label: "Galeri"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
            ],
          ),
        ),
      ),
    );
  }
}
