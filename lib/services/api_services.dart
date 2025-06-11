// lib/services/api_service.dart

import 'dart:io';
import 'package:dio/dio.dart';
import '../models/dokumen_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));

  // GET dokumen
  Future<List<Dokumen>> fetchDokumenList() async {
    try {
      final response = await _dio.get('/dokumen');
      List data = response.data['data'];
      return data.map((json) => Dokumen.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data dokumen: $e');
    }
  }

  // POST dokumen (upload file)
  Future<void> uploadDokumen({
    required String judul,
    required File file,
    required int idUser,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'judul_dokumen': judul,
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'id_user': idUser.toString(),
      });

      await _dio.post('/dokumen', data: formData);
    } catch (e) {
      throw Exception('Gagal mengunggah dokumen: $e');
    }
  }
}