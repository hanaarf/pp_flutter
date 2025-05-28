import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/variable.dart';

class FollowRepository {
  final _storage = FlutterSecureStorage();

  Future<bool> isFollowing(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/is-following/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final json = jsonDecode(response.body);
    return json['followed'] == true;
  }

  Future<void> follow(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/follow'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'following_id': userId}),
    );
    if (response.statusCode != 200) throw Exception('Gagal follow');
  }

  Future<void> unfollow(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/unfollow'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'following_id': userId}),
    );
    if (response.statusCode != 200) throw Exception('Gagal unfollow');
  }
}