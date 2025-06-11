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
      final userId = prefs.getInt('user_id'); // pastikan ini disimpan saat login

      if (token == null || userId == null) {
        throw Exception("Token atau ID user tidak ditemukan");
      }

      final formData = FormData.fromMap({
        'judul_dokumen': _judulController.text,
        'tgl_upload': '2025-06-11',
        'id_user': userId,
        'file': await MultipartFile.fromFile(
          _selectedFile!.path!,
          filename: _selectedFile!.name,
        ),
      });

      final response = await Dio().post(
        'http://10.0.2.2:8000/api/dokumen',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen berhasil diunggah')),
        );
      } else {
        print('Gagal upload. Status: {response.statusCode}');
        print('Respon: {response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload gagal: {response.data}')),
        );
      }
    } catch (e) {
      print("Upload error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Dokumen"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: "Judul Dokumen"),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text("Pilih File"),
            ),
            const SizedBox(height: 10),
            if (_selectedFile != null)
              Text("File dipilih: ${_selectedFile!.name}"),
            const SizedBox(height: 24),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                  onPressed: _uploadDokumen,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Dokumen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    foregroundColor: Colors.white,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
