// filepath: lib/models/latihan_materi_model.dart
class LatihanMateriModel {
  final int id;
  final String judul;
  final String subjudul;
  final String deskripsi;
  final String youtubeUrl;
  final int jumlahSoal;
  final int jumlahJawab;
  final String statusLatihan;

  LatihanMateriModel({
    required this.id,
    required this.judul,
    required this.subjudul,
    required this.deskripsi,
    required this.youtubeUrl,
    required this.jumlahSoal,
    required this.jumlahJawab,
    required this.statusLatihan,
  });

  factory LatihanMateriModel.fromJson(Map<String, dynamic> json) {
    return LatihanMateriModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      subjudul: json['subjudul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      youtubeUrl: json['youtube_url'] ?? '',
      jumlahSoal: json['jumlah_soal'] ?? 0,
      jumlahJawab: json['jumlah_jawab'] ?? 0,
      statusLatihan: json['status_latihan'] ?? 'belum',
    );
  }
}