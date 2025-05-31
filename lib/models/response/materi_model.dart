class MateriModel {
  final int id;
  final String judul;
  final String subjudul;
  final String deskripsi;
  final String videoUrl; 

  MateriModel({
    required this.id,
    required this.judul,
    required this.subjudul,
    required this.deskripsi,
    required this.videoUrl,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      subjudul: json['subjudul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      videoUrl: json['video_url'] ?? '',
    );
  }
}
