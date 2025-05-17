class MateriVideo {
  final int id;
  final String judul;
  final String deskripsi;
  final String youtubeUrl;
  final String createdAt;
  final String? jenjang;
  final String? kelas;

  MateriVideo({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.youtubeUrl,
    required this.createdAt,
    this.jenjang,
    this.kelas,
  });

  factory MateriVideo.fromJson(Map<String, dynamic> json) {
    return MateriVideo(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      youtubeUrl: json['youtube_url'],
      createdAt: json['created_at'],
      jenjang: json['jenjang'],
      kelas: json['kelas'],
    );
  }
}
