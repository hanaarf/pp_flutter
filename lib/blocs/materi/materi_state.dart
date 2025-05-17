import 'package:pp_flutter/models/response/materi_response.dart';

abstract class MateriState {}

class MateriInitial extends MateriState {}

class MateriLoading extends MateriState {}

class MateriLoaded extends MateriState {
  final List<MateriVideo> videos;

  MateriLoaded(this.videos);
}

class MateriError extends MateriState {
  final String message;

  MateriError(this.message);
}
