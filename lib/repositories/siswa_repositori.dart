import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pp_flutter/models/response/latihan_materi_model.dart';
import 'package:pp_flutter/models/response/leaderboardUser';
import 'package:pp_flutter/models/response/quis_model.dart';
import 'package:pp_flutter/models/response/user_model.dart';
import '../services/variable.dart';

class SiswaRepositori {
  final _storage = FlutterSecureStorage();

   Future<List<Map<String, dynamic>>> getJenjangList() async {
    final response = await http.get(Uri.parse('$baseUrl/jenjang'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Gagal memuat data jenjang');
    }
  }

  Future<List<Map<String, dynamic>>> getKelasList(int jenjangId) async {
    final response = await http.get(Uri.parse('$baseUrl/kelas/$jenjangId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Gagal memuat data kelas');
    }
  }

  Future<List<UserModel>> searchUsers(String keyword) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/siswa/search-users?q=$keyword'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data user');
    }
  }

  Future<List<LeaderboardUser>> getLeaderboard() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/siswa/leaderboard'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final json = jsonDecode(response.body);
    if (json['success'] != true) throw Exception("Gagal ambil leaderboard");

    return (json['data'] as List)
        .map((e) => LeaderboardUser.fromJson(e))
        .toList();
  }

  Future<List<LatihanMateriModel>> getLatihanMateri() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/siswa/latihan-materi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final json = jsonDecode(response.body);
    if (json['success'] != true) {
      throw Exception('Gagal memuat data latihan materi');
    }

    return (json['data'] as List)
        .map((e) => LatihanMateriModel.fromJson(e))
        .toList();
  }

  Future<List<LatihanSoalModel>> getLatihanSoal(int materiId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/siswa/latihan-soal/$materiId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final json = jsonDecode(response.body);
    if (json['success'] != true) throw Exception("Gagal ambil soal");

    return (json['data'] as List)
        .map((e) => LatihanSoalModel.fromJson(e))
        .toList();
  }

  Future<bool> kirimJawaban({
    required int latihanVideoId,
    required String jawabanUser,
  }) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/siswa/jawaban-soal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'latihan_video_id': latihanVideoId,
        'jawaban_user': jawabanUser.trim(), 
      }),
    );

    final json = jsonDecode(response.body);
    if (json['success'] != true) {
      throw Exception("Gagal simpan jawaban");
    }

    return json['is_benar'] == true;
  }


}
