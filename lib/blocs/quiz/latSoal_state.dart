import 'package:pp_flutter/models/response/quis_model.dart';

abstract class LatihanSoalState {}

class LatihanSoalInitial extends LatihanSoalState {}

class LatihanSoalLoading extends LatihanSoalState {}

class LatihanSoalLoaded extends LatihanSoalState {
  final List<LatihanSoalModel> soal;
  LatihanSoalLoaded(this.soal);
}

class LatihanSoalError extends LatihanSoalState {
  final String message;
  LatihanSoalError(this.message);
}
