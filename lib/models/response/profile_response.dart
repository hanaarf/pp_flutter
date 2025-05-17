class ProfileResponse {
  final String name;
  final String email;
  final String jenjang;
  final String kelas;
  final int belajarMenitPerHari;
  final int xpTotal; 

  ProfileResponse({
    required this.name,
    required this.email,
    required this.jenjang,
    required this.kelas,
    required this.belajarMenitPerHari,
    required this.xpTotal, 
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      name: json['name'],
      email: json['email'],
      jenjang: json['jenjang'] ?? '',
      kelas: json['kelas'] ?? '',
      belajarMenitPerHari: json['belajar_menit_per_hari'] ?? 0,
      xpTotal: json['xp_total'] ?? 0, 
    );
  }
}
