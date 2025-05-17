import 'package:pp_flutter/models/materi_model.dart';

abstract class RekomendasiState {}
class RekomendasiInitial extends RekomendasiState {}
class RekomendasiLoading extends RekomendasiState {}
class RekomendasiLoaded extends RekomendasiState {
  final List<MateriModel> materi;
  RekomendasiLoaded(this.materi);
}
class RekomendasiError extends RekomendasiState {
  final String message;
  RekomendasiError(this.message);
}
