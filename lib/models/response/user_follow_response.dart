class UserFollow {
  final int id;
  final String name;
  final String? image;
  final String? jenjang;
  final String? kelas;
  final int? xp;

  UserFollow({
    required this.id,
    required this.name,
    this.image,
    this.jenjang,
    this.kelas,
    this.xp,
  });

  factory UserFollow.fromJson(Map<String, dynamic> json) => UserFollow(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    jenjang: json['jenjang'],
    kelas: json['kelas'],
    xp: json['xp'],
  );
}