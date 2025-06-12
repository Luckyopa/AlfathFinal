import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDokumenPage extends StatefulWidget {
  final int idDokumen;
  final String judulAwal;
  final String fileNameAwal;

  const EditDokumenPage({
    Key? key,
    required this.idDokumen,
    required this.judulAwal,
    required this.fileNameAwal,
  }) : super(key: key);

  @override
  State<EditDokumenPage> createState() => _EditDokumenPageState();
}

class _EditDokumenPageState extends State<EditDokumenPage> {
  late TextEditingController _judulController;
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judulAwal);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _submit() async {
    if (_judulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dokumen tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      FormData formData = FormData.fromMap({
        "judul_dokumen": _judulController.text,
        if (_selectedFile != null)
          "file": await MultipartFile.fromFile(_selectedFile!.path!, filename: _selectedFile!.name),
      });

      final response = await Dio().post(
        'http://10.0.2.2:8000/api/dokumen/${widget.idDokumen}?_method=PUT',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Edit error: $e');
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
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Edit Dokumen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Dokumen',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pilih File
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(3, 3)),
                        const BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-3, -3)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_file, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          _selectedFile != null ? _selectedFile!.name : 'Ganti File (opsional)',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_selectedFile == null)
                  Text(widget.fileNameAwal, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 30),

                // Tombol Simpan
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _submit,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
