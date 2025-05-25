// 📁 lib/repositories/auth_repository.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/request/login_request.dart';
import '../models/request/register_request.dart';
import '../models/request/profile_request.dart';
import '../models/response/auth_response.dart';
import '../models/response/profile_response.dart';
import '../services/variable.dart';

class AuthRepository {
  final _storage = FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: loginRequest.toMap(),
    );

    if (response.statusCode == 200) {
      final data = LoginResponse.fromJson(jsonDecode(response.body));
      await _storage.write(key: 'token', value: data.token);
      return data.token;
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Login gagal');
      } catch (_) {
        throw Exception('Login gagal. Tidak ada data dari server.');
      }
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'token');
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    await _storage.delete(key: 'token');
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Registration failed');
      } catch (e) {
        throw Exception('Registration failed: ${response.body}');
      }
    }
  }

  Future<void> saveProfileData(ProfileRequest request) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/complete-registration'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: request.toMap(),
    );

    if (response.statusCode != 200) {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to save profile data');
      } catch (e) {
        throw Exception('Failed to save profile data: ${response.body}');
      }
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<ProfileResponse> getProfile() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileResponse.fromJson(data['data']);
    } else {
      throw Exception('Gagal mengambil data profil');
    }
  }

  Future<void> updateMenitBelajar(int menit) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/siswa/update-menit'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'menit': menit.toString()},
    );

    final json = jsonDecode(response.body);
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal update menit belajar');
    }
  }

  Future<void> updateProfile({
    required String name,
    required int jenjangId,
    required int kelasId,
  }) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/siswa/update-profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'name': name,
        'jenjang_id': jenjangId.toString(),
        'kelas_id': kelasId.toString(),
      },
    );

    final json = jsonDecode(response.body);
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal mengubah profil');
    }
  }

  Future<void> updateAvatar(String avatar) async {
    final token = await _storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('$baseUrl/siswa/update-avatar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'avatar': avatar}),
    );

    final json = jsonDecode(response.body);
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? 'Gagal mengubah avatar');
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
  final response = await http.post(
    Uri.parse('$baseUrl/forgot-password'),
    body: {'email': email},
  );

  if (response.statusCode != 200) {
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Gagal mengirim email reset password');
  }
}

}
