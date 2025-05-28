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

  Future<List<dynamic>> getFollowers(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/followers/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load followers');
    }
  }

  Future<List<dynamic>> getFollowing(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/following/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load following');
    }
  }

  Future<int> getFollowersCount(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/followers/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception('Failed to load followers count');
    }
  }

  Future<int> getFollowingCount(int userId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/following/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception('Failed to load following count');
    }
  }
}