class ProfileRequest {
  final int jenjangId;
  final int kelasId;
  final int menitPerHari;

  ProfileRequest({
    required this.jenjangId,
    required this.kelasId,
    required this.menitPerHari,
  });

  Map<String, String> toMap() {
    return {
      'jenjang_id': jenjangId.toString(),
      'kelas_id': kelasId.toString(),
      'belajar_menit_per_hari': menitPerHari.toString(),
    };
  }
}
