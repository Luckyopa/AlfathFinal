import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahDokumenPage extends StatefulWidget {
  const TambahDokumenPage({super.key});

  @override
  State<TambahDokumenPage> createState() => _TambahDokumenPageState();
}

class _TambahDokumenPageState extends State<TambahDokumenPage> {
  final _judulController = TextEditingController();
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _uploadDokumen() async {
    if (_judulController.text.isEmpty || _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan file wajib diisi')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final userId = prefs.getInt('user_id');

      String fileName = _selectedFile!.name;
      FormData formData = FormData.fromMap({
        "judul_dokumen": _judulController.text,
        "file": await MultipartFile.fromFile(
          _selectedFile!.path!,
          filename: fileName,
        ),
        "id_user": userId,
        "tgl_upload": DateTime.now().toIso8601String().substring(
          0,
          10,
        ), // format: YYYY-MM-DD
      });

      final response = await Dio().post(
        'http://10.0.2.2:8000/api/dokumen',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('Status: ${e.response?.statusCode}');
        print(
          'Error data: ${e.response?.data}',
        ); // ← ini akan kasih tahu validasi mana yang gagal
      } else {
        print("Upload error: $e");
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Column(
        children: [
          // Header
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
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Tambah Dokumen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48), // biar simetris
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Judul dokumen
                TextField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Dokumen',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Pilih File
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: Offset(3, 3),
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 6,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_file, color: Colors.grey),
                        const SizedBox(width: 8),
                        // Cegah overflow
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Text(
                            _selectedFile != null
                                ? _selectedFile!.name
                                : 'Pilih File',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol Upload
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadDokumen,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text(
                    "Upload Dokumen",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
