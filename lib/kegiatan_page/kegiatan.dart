import 'package:flutter/material.dart';
import 'tambah_kegiatan.dart';
import 'detail_kegiatan.dart';
import 'package:alfath/beranda_page/beranda_admin.dart';
import 'package:alfath/dokumen_page/dokumen.dart';
import 'package:alfath/dokumentasi_page/dokumentasi.dart';
import 'package:alfath/profile_page/profile.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  final List<Map<String, String>> allKegiatan = [
    {
      'nama': 'Bukber Hari raya',
      'mulai': '2025-05-25',
      'selesai': '2025-05-25',
      'lokasi': 'Aula 1',
    },
    {
      'nama': 'Laporan Keuangan Mei',
      'mulai': '2025-05-24',
      'selesai': '2025-05-25',
      'lokasi': 'Ruang B101',
    },
  ];

  List<Map<String, String>> filteredKegiatan = [];
  String selectedMonth = 'Mei';
  String selectedYear = '2025';
  String searchText = '';
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    filteredKegiatan = allKegiatan;
  }

  void filterKegiatan() {
    setState(() {
      filteredKegiatan = allKegiatan.where((kegiatan) {
        final date = DateTime.parse(kegiatan['mulai']!);
        final monthMatch = date.month == 5; // Mei
        final yearMatch = date.year.toString() == selectedYear;
        final searchMatch = kegiatan['mulai']!.contains(searchText);
        return monthMatch && yearMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
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
                  Text("Kegiatan",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Jumlah Kegiatan",
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Chart placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF2F2F2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(4, 4)),
                    const BoxShadow(
                        color: Colors.white,
                        blurRadius: 8,
                        offset: Offset(-4, -4)),
                  ],
                ),
                child: const Center(child: Text("Chart Placeholder")),
              ),
            ),

            const SizedBox(height: 24),

            // Search + Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Search
                  TextField(
                    onChanged: (value) {
                      searchText = value;
                      filterKegiatan();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Cari berdasarkan tanggal...",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter buttons
                  Wrap(
                    spacing: 12,
                    children: ['2025', '2024'].map((year) {
                      final isSelected = selectedYear == year;
                      return ElevatedButton(
                        onPressed: () {
                          selectedYear = year;
                          filterKegiatan();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.red.shade100 : Colors.white,
                          foregroundColor:
                              isSelected ? Colors.red : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                        child: Text("Tahun $year"),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // List kegiatan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  itemCount: filteredKegiatan.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    final kegiatan = filteredKegiatan[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DetailKegiatanPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar dummy
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: AssetImage('assets/banner.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(kegiatan['nama']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("Mulai: ${kegiatan['mulai']}"),
                            Text("Selesai: ${kegiatan['selesai']}"),
                            Text("Lokasi: ${kegiatan['lokasi'] ?? '-'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Add
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahKegiatanPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),

      // Bottom Navigation Bar
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
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DokumenPage()),
                  );
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
