
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alfath/dokumen_page/dokumen.dart';
import 'package:alfath/kegiatan_page/kegiatan.dart';
import 'package:alfath/dokumentasi_page/dokumentasi.dart';
import 'package:alfath/profile_page/profile.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int totalUser = 0;
  int totalKegiatan = 0;
  int totalDokumen = 0;

  @override
  void initState() {
    super.initState();
    fetchStatistik();
  }

  Future<void> fetchStatistik() async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final userRes = await dio.get(
        'http://10.0.2.2:8000/api/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final kegiatanRes = await dio.get(
        'http://10.0.2.2:8000/api/kegiatan',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dokumenRes = await dio.get(
        'http://10.0.2.2:8000/api/dokumen',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        totalUser = (userRes.data['data'] as List?)?.length ?? 0;
        totalKegiatan = (kegiatanRes.data['data'] as List?)?.length ?? 0;
        totalDokumen = (dokumenRes.data['data'] as List?)?.length ?? 0;
      });
    } catch (e) {
      print("Gagal mengambil data statistik: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Merah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris atas: logo dan foto profil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo_alfath.png', width: 50, height: 50),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('access_token');
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Hello\nKevin Septianus Tjahjadi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade800,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dzuhur 11:54",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "Minggu, 11 Mei 2025\n13 Zulkaidah 1446",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "2 Jam 52 Menit",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text("Bandung", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _statistikCard("Jumlah User", totalUser),
            const SizedBox(height: 20),
            _statistikCard("Jumlah Kegiatan", totalKegiatan),
            const SizedBox(height: 20),
            _statistikCard("Jumlah Dokumen", totalDokumen),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFFA7281E),
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (_) => DokumenPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => KegiatanPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DokumentasiPage()));
                break;
              case 4:
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: 'Dokumen'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Kalender'),
            BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Galeri'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
    }
  }

Widget _statistikCard(String label, int value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity, // ⬅️ Lebar full
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 252, 252, 252),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
