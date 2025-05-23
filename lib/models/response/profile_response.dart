class ProfileResponse {
  final String name;
  final String email;
  final String jenjang;
  final String kelas;
  final int belajarMenitPerHari;
  final int xpTotal; 
   final String image;

  ProfileResponse({
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
      name: json['name'],
      email: json['email'],
      jenjang: json['jenjang'] ?? '',
      kelas: json['kelas'] ?? '',
      belajarMenitPerHari: json['belajar_menit_per_hari'] ?? 0,
      xpTotal: json['xpTotal'] ?? 0, 
      image: json['image'] ?? 'avatar.png',
    );
  }
}
