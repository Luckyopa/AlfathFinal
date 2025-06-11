
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class EditDokumenPage extends StatefulWidget {
  final int idDokumen;
  final String judulAwal;
  final String fileNameAwal;

  const EditDokumenPage({
    super.key,
    required this.idDokumen,
    required this.judulAwal,
    required this.fileNameAwal,
  });

  @override
  State<EditDokumenPage> createState() => _EditDokumenPageState();
}

class _EditDokumenPageState extends State<EditDokumenPage> {
  final _judulController = TextEditingController();
  PlatformFile? _selectedFile;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _judulController.text = widget.judulAwal;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _updateDokumen() async {
    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      FormData data = FormData.fromMap({
        'judul_dokumen': _judulController.text,
        if (_selectedFile != null)
          'file_path': await MultipartFile.fromFile(
            _selectedFile!.path!,
            filename: _selectedFile!.name,
          ),
      });

      final response = await Dio().post(
        'http://10.0.2.2:8000/api/dokumen/${widget.idDokumen}?_method=PUT',
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen berhasil diperbarui')),
        );
      } else {
        throw Exception("Gagal update dokumen");
      }
    } catch (e) {
      print("Update error: \$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update dokumen")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Dokumen"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              label: const Text("Ganti File (opsional)"),
            ),
            const SizedBox(height: 10),
            Text(_selectedFile?.name ?? widget.fileNameAwal),
            const SizedBox(height: 24),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _updateDokumen,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Perubahan"),
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
