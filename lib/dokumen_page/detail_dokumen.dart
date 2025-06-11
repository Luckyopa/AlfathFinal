import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'tambah_dokumen.dart';
import 'edit_dokumen.dart';

class DetailDokumenPage extends StatefulWidget {
  final int idFakultas;
  final String namaFakultas;

  const DetailDokumenPage({
    super.key,
    required this.idFakultas,
    required this.namaFakultas,
  });

  @override
  State<DetailDokumenPage> createState() => _DetailDokumenPageState();
}

class _DetailDokumenPageState extends State<DetailDokumenPage> {
  List dokumenList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDokumen();
  }

  Future<void> fetchDokumen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await Dio().get(
        'http://10.0.2.2:8000/api/dokumen',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          dokumenList =
              response.data['data']
                  .where(
                    (dok) => dok['user']['id_fakultas'] == widget.idFakultas,
                  )
                  .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching dokumen: ${e.toString()}");
    }
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
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dokumen berhasil dihapus")),
        );
      }
    } catch (e) {
      print("Gagal hapus dokumen: ${e.toString()}");
    }
  }

  void _showDeleteConfirmation(int id) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Konfirmasi Penghapusan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text("Apakah Anda yakin ingin menghapus dokumen ini?"),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _hapusDokumen(id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokumen - ${widget.namaFakultas}", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahDokumenPage()),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : dokumenList.isEmpty
              ? const Center(child: Text("Tidak ada dokumen"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 255, 255),
                  ),
                  columns: const [
                    DataColumn(label: Text('Judul')),
                    DataColumn(label: Text('Tanggal Upload')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List<DataRow>.generate(dokumenList.length, (index) {
                    final dok = dokumenList[index];
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>((
                        Set<MaterialState> states,
                      ) {
                        return index % 2 == 0
                            ? Colors.white
                            : Colors.grey.shade100;
                      }),
                      cells: [
                        DataCell(Text(dok['judul_dokumen'] ?? '')),
                        DataCell(
                          Text(
                            dok['tgl_upload']?.toString().split('T')[0] ?? '',
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _showDeleteConfirmation(
                                      dok['id_dokumen'],
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditDokumenPage(
                                            idDokumen: dok['id_dokumen'],
                                            judulAwal: dok['judul_dokumen'],
                                            fileNameAwal:
                                                dok['file_path']
                                                    ?.toString()
                                                    .split('/')
                                                    .last ??
                                                'file',
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
    );
  }
}
