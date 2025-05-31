class MateriDetailResponse {
  final int id;
  final String judul;
  final String deskripsi;
  final String youtubeUrl;
  final String createdAt;

  MateriDetailResponse({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.youtubeUrl,
    required this.createdAt,
  });

  factory MateriDetailResponse.fromJson(Map<String, dynamic> json) {
    return MateriDetailResponse(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      youtubeUrl: json['youtube_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
