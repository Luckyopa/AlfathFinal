import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alfath/dokumen_page/detail_dokumen.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'package:alfath/kegiatan_page/kegiatan.dart';
import 'package:alfath/dokumentasi_page/dokumentasi.dart';
import 'package:alfath/profile_page/profile.dart';

class DokumenPage extends StatefulWidget {
  const DokumenPage({super.key});

  @override
  State<DokumenPage> createState() => _DokumenPageState();
}

class _DokumenPageState extends State<DokumenPage> {
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> fakultasList = const [
    {"id": 1, "nama": "FIT", "warna": Colors.green},
    {"id": 2, "nama": "FEB", "warna": Colors.cyan},
    {"id": 3, "nama": "FIK", "warna": Colors.orange},
    {"id": 4, "nama": "FRI", "warna": Colors.green},
    {"id": 5, "nama": "FTE", "warna": Colors.blue},
    {"id": 6, "nama": "FIF", "warna": Colors.amber},
    {"id": 7, "nama": "FKS", "warna": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.red.shade900,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 30,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Dokumen",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Jumlah Dokumen",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // CHART AREA NEUMORPH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      offset: Offset(-4, -4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Chart Placeholder",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
         Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Text(
                "Dokumen Pusat",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // DOKUMEN PUSAT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  FakultasCard(nama: "Alfath", warna: Colors.red, id: 0),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DOKUMEN FAKULTAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Text(
                "Dokumen Fakultas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children:
                    fakultasList.map((fakultas) {
                      return FakultasCard(
                        nama: fakultas['nama'],
                        warna: fakultas['warna'],
                        id: fakultas['id'],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminPage()),
                  );
                  break;
                case 1:
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
}

class FakultasCard extends StatelessWidget {
  final String nama;
  final Color warna;
  final int id;
  final bool isFullWidth;

  const FakultasCard({
    Key? key,
    required this.nama,
    required this.warna,
    required this.id,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DetailDokumenPage(
                  idFakultas: id,
                  namaFakultas: nama, // tambahkan ini
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
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
        child: Row(
          children: [
            Icon(Icons.folder, color: warna, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                nama,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
