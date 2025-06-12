import 'package:flutter/material.dart';

class DetailDokumentasiPage extends StatelessWidget {
  const DetailDokumentasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 24),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Detail Dokumentasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ISI
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buka Bersama Hari Raya Lebaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset("assets/banner.png"),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Foto Kegiatan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: Text("Foto 1")),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: Text("Foto 2")),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Video Kegiatan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle, size: 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
