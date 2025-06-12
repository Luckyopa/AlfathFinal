import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'tambah_dokumen.dart';
import 'edit_dokumen.dart';

class DetailDokumenPage extends StatefulWidget {
  final int idFakultas;
  final String namaFakultas;

  const DetailDokumenPage({
    Key? key,
    required this.idFakultas,
    required this.namaFakultas,
  }) : super(key: key);

  @override
  State<DetailDokumenPage> createState() => _DetailDokumenPageState();
}

class _DetailDokumenPageState extends State<DetailDokumenPage> {
  List dokumenList = [];
  List filteredList = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedType = 'Semua';

  @override
  void initState() {
    super.initState();
    fetchDokumen();
  }

  Future<void> fetchDokumen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await Dio().get(
        'http://10.0.2.2:8000/api/dokumen',
        options: Options(
          headers: {
            'Authorization': 'Bearer ' + token!,
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final allDocs =
            response.data['data']
                .where((dok) => dok['user']['id_fakultas'] == widget.idFakultas)
                .toList();

        setState(() {
          dokumenList = allDocs;
          filteredList = allDocs;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }

  void filterDokumen() {
    setState(() {
      filteredList =
          dokumenList.where((doc) {
            final titleMatch = doc['judul_dokumen'].toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final typeMatch =
                selectedType == 'Semua' ||
                doc['file_path'].toLowerCase().endsWith(
                  selectedType.toLowerCase(),
                );
            return titleMatch && typeMatch;
          }).toList();
    });
  }

  void showDeleteSheet(int id) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hapus Dokumen?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text("Apakah kamu yakin ingin menghapus dokumen ini?"),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                      ),
                      onPressed: () {
                        _hapusDokumen(id);
                        Navigator.pop(context);
                      },
                      child: const Text("Hapus"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getFileIcon(String path) {
    if (path.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (path.endsWith('.doc') || path.endsWith('.docx'))
      return Icons.description;
    if (path.endsWith('.ppt') || path.endsWith('.pptx')) return Icons.slideshow;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Dokumen - ${widget.namaFakultas}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(3, 3),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 6,
                        offset: Offset(-3, -3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      filterDokumen();
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari dokumen...",
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children:
                      ['Semua', '.pdf', '.docx', '.pptx'].map((type) {
                        final isSelected = selectedType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = type;
                              filterDokumen();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.red.shade100
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 6,
                                  offset: const Offset(2, 2),
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 6,
                                  offset: Offset(-2, -2),
                                ),
                              ],
                            ),
                            child: Text(
                              type.toUpperCase().replaceAll('.', ''),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          // LIST
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) {
                      final doc = filteredList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 252, 252, 252),
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
                            Icon(
                              _getFileIcon(doc['file_path']),
                              color: Colors.red.shade400,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['judul_dokumen'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc['tgl_upload'].substring(0, 10),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 0, 145, 255),
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditDokumenPage(
                                          idDokumen: doc['id_dokumen'],
                                          judulAwal: doc['judul_dokumen'],
                                          fileNameAwal:
                                              doc['file_path']
                                                  ?.toString()
                                                  .split('/')
                                                  .last ??
                                              'file',
                                        ),
                                  ),
                                );

                                if (result == true) {
                                  fetchDokumen(); 
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () => showDeleteSheet(doc['id_dokumen']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahDokumenPage()),
          );

          if (result == true) {
            fetchDokumen(); // Refresh otomatis setelah kembali
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _hapusDokumen(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await Dio().delete(
        'http://10.0.2.2:8000/api/dokumen/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          dokumenList.removeWhere((doc) => doc['id_dokumen'] == id);
          filteredList.removeWhere((doc) => doc['id_dokumen'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dokumen berhasil dihapus")),
        );
      }
    } catch (e) {
      print("Gagal hapus dokumen: ${e.toString()}");
    }
  }
}
