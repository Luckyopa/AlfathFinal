import 'package:flutter/material.dart';
import 'detail_dokumentasi.dart';
import 'tambah_dokumentasi.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'package:alfath/dokumen_page/dokumen.dart';
import 'package:alfath/kegiatan_page/kegiatan.dart';
import 'package:alfath/profile_page/profile.dart';

class DokumentasiPage extends StatefulWidget {
  const DokumentasiPage({super.key});

  @override
  State<DokumentasiPage> createState() => _DokumentasiPageState();
}

class _DokumentasiPageState extends State<DokumentasiPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: const BorderRadius.only(
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dokumentasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Jumlah Dokumentasi",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          // Konten scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                        hint: const Text('Tahun :'),
                        items: [],
                        onChanged: null,
                      ),
                      DropdownButton<String>(
                        hint: const Text('Bulan:'),
                        items: [],
                        onChanged: null,
                      ),
                      DropdownButton<String>(
                        hint: const Text('Tanggal:'),
                        items: [],
                        onChanged: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(), // Disable scroll agar tidak bentrok
                    shrinkWrap: true, // Penting agar tidak infinite height
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
                            children: [
                              Expanded(child: Image.asset("assets/banner.png")),
                              const Padding(
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
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDokumentasiPage()),
          );
        },
        backgroundColor: Colors.red[900],
        child: const Icon(Icons.add, color: Colors.white),
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage()));
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DokumenPage()));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const KegiatanPage()));
                  break;
                case 3:
                  break;
                case 4:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
