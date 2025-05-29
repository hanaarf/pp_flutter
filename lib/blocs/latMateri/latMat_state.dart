import 'package:pp_flutter/models/response/latihan_materi_model.dart';

abstract class LatihanMateriState {}

class LatihanMateriInitial extends LatihanMateriState {}

class LatihanMateriLoading extends LatihanMateriState {}

class LatihanMateriLoaded extends LatihanMateriState {
  final List<LatihanMateriModel> materi;

  LatihanMateriLoaded(this.materi);
}

class LatihanMateriError extends LatihanMateriState {
  final String message;

  LatihanMateriError(this.message);
}
