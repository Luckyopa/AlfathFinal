// dokumentasi_page.dart
import 'package:flutter/material.dart';
import 'detail_dokumentasi.dart';
import 'tambah_dokumentasi.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'package:alfath/dokumen_page/dokumen.dart';
import 'package:alfath/kegiatan_page/kegiatan.dart';
import 'package:alfath/profile_page/profile.dart';


class DokumentasiPage extends StatelessWidget {
  const DokumentasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: false,
        title: const Text('Dokumentasi', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Dokumentasi',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: Text('Tahun :'),
                  items: [],
                  onChanged: null,
                ),
                DropdownButton<String>(
                  hint: Text('Bulan:'),
                  items: [],
                  onChanged: null,
                ),
                DropdownButton<String>(
                  hint: Text('Tanggal:'),
                  items: [],
                  onChanged: null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetailDokumentasiPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: const [
                          Expanded(child: Placeholder()),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bukber Hari raya Lebaran', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Minggu, 25 Mei 2025', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDokumentasiPage()),
          );
        },
        backgroundColor: Colors.red[900],
        child: const Icon(Icons.add),
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
          currentIndex: 3,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFFA7281E),
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AdminPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DokumenPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KegiatanPage()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DokumentasiPage(),
                  ),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
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
        )),
    );
  }
}
