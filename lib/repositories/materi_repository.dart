import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pp_flutter/models/response/materi_model.dart';
import 'package:pp_flutter/models/response/materi_response.dart';
import '../services/variable.dart';

class MateriRepository {
  final _storage = FlutterSecureStorage();

  Future<List<MateriVideo>> getMateriVideos() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$baseUrl/materi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data as List).map((e) => MateriVideo.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat materi');
    }
  }

  Future<MateriVideo> getMateriDetail(int id) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/materi/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return MateriVideo.fromJson(data); // pakai model yang sama
    } else {
      throw Exception('Gagal memuat detail materi');
    }
  }

  Future<List<MateriModel>> searchMateri(String keyword) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/materi/search?keyword=$keyword'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data as List).map((e) {
        return MateriModel(
          id: e['id'],
          judul: e['judul'],
          subjudul: e['subjudul'],
          deskripsi: e['deskripsi'],
          videoUrl: e['youtube_url'],
        );
      }).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mencari materi');
    }
  }

  Future<List<MateriModel>> getRekomendasiMateri() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/materi-limit'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data as List).map((e) {
        return MateriModel(
          id: e['id'],
          judul: e['judul'],
          subjudul: e['subjudul'],
          deskripsi: e['deskripsi'],
          videoUrl: e['youtube_url'],
        );
      }).toList();
    } else {
      throw Exception('Gagal memuat rekomendasi materi');
    }
  }
}
