import 'package:flutter/material.dart';

/// Widget kartu untuk menampilkan fakultas dalam bentuk tombol horizontal.
/// Dapat digunakan untuk navigasi ke halaman dokumen per fakultas.
class FakultasCard extends StatelessWidget {
  final String title;           // Nama fakultas
  final Color iconColor;        // Warna ikon
  final VoidCallback? onTap;    // Fungsi saat ditekan
  final IconData icon;          // Ikon (default: insert_drive_file)

  const FakultasCard({
    Key? key,
    required this.title,
    required this.iconColor,
    this.onTap,
    this.icon = Icons.insert_drive_file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'edit_dokumen.dart';
// import 'tambah_dokumen.dart';

// class DetailDokumenPage extends StatefulWidget {
//   final int idFakultas;
//   final String namaFakultas;

//   const DetailDokumenPage({
//     super.key,
//     required this.idFakultas,
//     required this.namaFakultas,
//   });

//   @override
//   State<DetailDokumenPage> createState() => _DetailDokumenPageState();
// }

// class _DetailDokumenPageState extends State<DetailDokumenPage> {
//   List dokumenList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchDokumen();
//   }

//   Future<void> fetchDokumen() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token'); // sudah diperbaiki

//       if (token == null) {
//         print('Token tidak ditemukan');
//         return;
//       }

//       final response = await Dio().get(
//         'http://10.0.2.2:8000/api/dokumen',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           dokumenList = response.data['data'];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching dokumen: ${e.toString()}");
//     }
//   }

// Future<void> _hapusDokumen(int id) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) {
//       throw Exception('Token tidak ditemukan');
//     }

//     final response = await Dio().delete(
//       'http://10.0.2.2:8000/api/dokumen/$id', // Gunakan interpolasi string
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',  // Gunakan interpolasi string
//           'Accept': 'application/json',
//         },
//       ),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         dokumenList.removeWhere((doc) => doc['id_dokumen'] == id);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Dokumen berhasil dihapus")),
//       );
//     }
//   } catch (e) {
//     print('Gagal hapus dokumen: ${e.toString()}');
//     if (e is DioException) {
//       print('Status Code: ${e.response?.statusCode}');
//       print('Response Data: ${e.response?.data}');
//     }
//   }
// }


//   Future<void> previewFile(String url) async {
//     try {
//       final response = await Dio().get(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );
//       final tempDir = await getTemporaryDirectory();
//       final filePath = '\${tempDir.path}/preview_file';
//       final file = File(filePath);
//       await file.writeAsBytes(response.data);
//       OpenFile.open(filePath);
//     } catch (e) {
//       print("Gagal membuka file: \$e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Gagal membuka file")));
//     }
//   }

//   void _showDeleteConfirmation(BuildContext context, int idDokumen) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Wrap(
//             children: [
//               const Center(
//                 child: Text(
//                   "Hapus Dokumen?",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text("Apakah Anda yakin ingin menghapus dokumen ini?"),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Batal"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _hapusDokumen(idDokumen);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade900,
//                       ),
//                       child: const Text("Hapus"),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dokumen - \${widget.namaFakultas}"),
//         backgroundColor: Colors.red.shade900,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : dokumenList.isEmpty
//               ? const Center(child: Text("Tidak ada dokumen"))
//               : ListView.builder(
//                 itemCount: dokumenList.length,
//                 itemBuilder: (context, index) {
//                   final dok = dokumenList[index];
//                   final fileName = dok['file_path']?.split('/')?.last ?? 'file';
//                   return Card(
//                     elevation: 2,
//                     child: ListTile(
//                       leading: const Icon(
//                         Icons.insert_drive_file,
//                         color: Colors.red,
//                       ),
//                       title: Text(dok['judul_dokumen'] ?? '-'),
//                       subtitle: Text("Upload: ${dok['tgl_upload'] ?? '-'}"),
//                       onTap: () {
//                         if (dok['file_path'] != null) {
//                           previewFile(
//                             "http://10.0.2.2:8000/storage/${dok['file_path']}",
//                           );
//                         }
//                       },
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.orange),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (_) => EditDokumenPage(
//                                         idDokumen: dok['id_dokumen'],
//                                         judulAwal: dok['judul_dokumen'],
//                                         fileNameAwal: fileName,
//                                       ),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed:
//                                 () => _showDeleteConfirmation(
//                                   context,
//                                   dok['id_dokumen'],
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.red.shade900,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const TambahDokumenPage()),
//           ).then((_) => fetchDokumen());
//         },
//         label: const Text("Tambah Dokumen"),
//         icon: const Icon(Icons.add),
//       ),
//     );
//   }
// }
