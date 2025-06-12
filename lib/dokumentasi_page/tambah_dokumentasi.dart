import 'package:flutter/material.dart';

class TambahDokumentasiPage extends StatelessWidget {
  const TambahDokumentasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Tambah Dokumentasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ISI FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Kegiatan'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField(
                    items: const [],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih Kegiatan',
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Tanggal'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Pilih Tanggal',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Dokumentasi Foto Kegiatan'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Masukan Foto',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                        ),
                        onPressed: () {},
                        child: const Text('Pilih Foto', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('Dokumentasi Video Kegiatan'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Masukan Video',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                        ),
                        onPressed: () {},
                        child: const Text('Pilih Video', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        onPressed: () {},
                        child: const Text('Batalkan'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                        ),
                        onPressed: () {},
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
