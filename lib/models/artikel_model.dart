class Artikel {
  final int id;
  final String judul;
  final String deskripsi;
  final String coverImage;

  Artikel({required this.id, required this.judul, required this.deskripsi, required this.coverImage});

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      coverImage: json['cover_image'],
    );
  }
}