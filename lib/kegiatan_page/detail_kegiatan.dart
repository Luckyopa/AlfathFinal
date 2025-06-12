import 'package:flutter/material.dart';

class DetailKegiatanPage extends StatelessWidget {
  const DetailKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER REDESAIN
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Detail Kegiatan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Judul kegiatan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Buka Bersama Hari Raya Lebaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Gambar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 140,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Informasi kegiatan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Informasi Kegiatan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Nama Acara    : Bukber Hari Raya'),
                    Text('Tanggal Acara : Minggu, 25 Mei 2025'),
                    Text('Waktu Acara   : 17:00 - 18:45'),
                    Text('Tempat Acara  : Masjid Syamsul Ulum'),
                    Text('Kuota Pendaftaran : 50 Orang'),
                    Text('Contact Person : +6284637128318'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Deskripsi kegiatan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Kegiatan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bismillah,\n'
                      'Bukber Hari raya Lebaran ✨TWILIGHT SPECTRUM✨ Satu dekade perjalanan dakwah Al-Fath Telkom University🚀\n\n'
                      'Sharing Session | Bazaar & Tenant | Stand Up Comedy | Live Music Performance\n\n'
                      '🎤 Guest Star: Bachrul Alam\n'
                      '🎨 Tema: Live, Love, Laugh\n\n'
                      '‼ FREE (NO HTM) ‼',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
