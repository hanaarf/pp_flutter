import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/artikel_model.dart';
import '../services/variable.dart';

class ArtikelRepository {
  final _storage = FlutterSecureStorage();

  Future<List<Artikel>> getArtikel() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(Uri.parse('$baseUrl/artikel'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> artikelData = data['data'];
      return artikelData.map((a) => Artikel.fromJson(a)).toList();
    } else {
      throw Exception('Gagal mengambil artikel');
    }
  }
}
