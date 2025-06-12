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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchStatistik();
  }

  Future<void> fetchStatistik() async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');


      final userRes = await dio.get(
        'http://10.0.2.2:8000/api/user',
        options: Options(headers: {'Authorization': 'Bearer ' + token!}),
      );
      final kegiatanRes = await dio.get(
        'http://10.0.2.2:8000/api/kegiatan',
        options: Options(headers: {'Authorization': 'Bearer ' + token!}),
      );
      final dokumenRes = await dio.get(
        'http://10.0.2.2:8000/api/dokumen',
        options: Options(headers: {'Authorization': 'Bearer ' + token!}),
      );

      print("User data count: " + userRes.data['data'].length.toString());
      print(
        "Kegiatan data count: " + kegiatanRes.data['data'].length.toString(),
      );
      print("Dokumen data count: " + dokumenRes.data['data'].length.toString());
      setState(() {
        totalUser = (userRes.data['data'] as List?)?.length ?? 0;
        totalKegiatan = (kegiatanRes.data['data'] as List?)?.length ?? 0;
        totalDokumen = (dokumenRes.data['data'] as List?)?.length ?? 0;
      });
    } catch (e) {
      if (e is DioException) {
        print("Fetch error: \${e.response?.statusCode}");
        print("Data error: \${e.response?.data}");
      } else {
        print("Error: " + e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10,
          offset: Offset(4, 4),
        ),
        BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(-4, -4)),
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hello",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      Text(
                        "Kevin Septianus Tjahjadi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.red.shade700),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // JADWAL SHOLAT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dzuhur 11:54",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "2 Jam 52 Menit",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Divider(),
                    Text("Minggu, 11 Mei 2025 - 13 Zulkaidah 1446"),
                    Text("Bandung"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // STATISTIK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  statCard(
                    Icons.people,
                    "Jumlah User",
                    totalUser.toString(),
                    cardDecoration,
                  ),
                  SizedBox(height: 16),
                  statCard(
                    Icons.event,
                    "Jumlah Kegiatan",
                    totalKegiatan.toString(),
                    cardDecoration,
                  ),
                  SizedBox(height: 16),
                  statCard(
                    Icons.folder,
                    "Jumlah Dokumen",
                    totalDokumen.toString(),
                    cardDecoration,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
            BoxShadow(
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
            backgroundColor: Color.fromARGB(255, 250, 250, 250),
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DokumenPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => KegiatanPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DokumentasiPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  );
                  break;
              }
            },
            selectedItemColor: Colors.red.shade700,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_drive_file),
                label: "Dokumen",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Kalender",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Galeri"),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(
    IconData icon,
    String label,
    String value,
    BoxDecoration decoration,
  ) {
    return Container(
      decoration: decoration,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.red.shade700),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade700)),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
