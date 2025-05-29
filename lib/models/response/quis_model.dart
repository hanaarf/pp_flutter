class LatihanSoalModel {
  final int id;
  final String pertanyaan;
  final String opsiA;
  final String opsiB;
  final String opsiC;
  final String jawaban;
  final int xp;
  final bool sudahDijawab;

  LatihanSoalModel({
    required this.id,
    required this.pertanyaan,
    required this.opsiA,
    required this.opsiB,
    required this.opsiC,
    required this.jawaban,
    required this.xp,
    required this.sudahDijawab,
  });

  factory LatihanSoalModel.fromJson(Map<String, dynamic> json) {
    return LatihanSoalModel(
      id: json['id'],
      pertanyaan: json['pertanyaan'],
      opsiA: json['opsi_a'],
      opsiB: json['opsi_b'],
      opsiC: json['opsi_c'],
      jawaban: json['jawaban'],
      xp: json['xp'],
      sudahDijawab: json['sudah_dijawab'] ?? false,
    );
  }
}