class ProfileResponse {
  final int id;
  final String name;
  final String email;
  final String jenjang;
  final String kelas;
  final int belajarMenitPerHari;
  final int xpTotal; 
  final String image;

  ProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.jenjang,
    required this.kelas,
    required this.belajarMenitPerHari,
    required this.xpTotal, 
    required this.image, 
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      jenjang: json['jenjang'] ?? '',
      kelas: json['kelas'] ?? '',
      belajarMenitPerHari: json['belajar_menit_per_hari'] is int
          ? json['belajar_menit_per_hari']
          : int.tryParse(json['belajar_menit_per_hari'].toString()) ?? 0,
      xpTotal: json['xpTotal'] is int
          ? json['xpTotal']
          : int.tryParse(json['xpTotal'].toString()) ?? 0,
      image: json['image'] ?? 'avatar.png',
    );
  }
}
