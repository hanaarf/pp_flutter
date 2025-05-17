class MateriModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String videoUrl; // <- tambahkan ini

  MateriModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.videoUrl,
  });
}
