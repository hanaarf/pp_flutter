import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pp_flutter/models/leaderboardUser';
import 'package:pp_flutter/models/user_model.dart';
import '../services/variable.dart';

class SiswaRepositori {
  final _storage = FlutterSecureStorage();

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
}
