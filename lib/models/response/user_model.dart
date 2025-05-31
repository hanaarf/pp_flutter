class UserModel {
  final int id;
  final String nama;
  final String xp;
  final String img;
  final String jenjang;
  final String kelas;
  final String createdAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.xp,
    required this.img,
    required this.jenjang,
    required this.kelas,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? '',
      xp: json['xp'].toString(),
      img: 'assets/avatar/${json['img']}',
      jenjang: json['jenjang'] ?? '',
      kelas: json['kelas'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
