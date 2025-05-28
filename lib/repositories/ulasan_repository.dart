import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/variable.dart';

class UlasanRepository {
  final _storage = FlutterSecureStorage();

  Future<void> kirimUlasan(String deskripsi) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/ulasan'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'deskripsi': deskripsi},
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengirim ulasan');
    }
  }

  Future<bool> cekSudahUlasan() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/ulasan/status'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sudah_ulasan'] ?? false;
    }
    throw Exception('Gagal cek status ulasan');
  }
}
