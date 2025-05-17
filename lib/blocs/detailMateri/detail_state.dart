import 'package:pp_flutter/models/response/materi_response.dart';

abstract class MateriDetailState {}

class MateriDetailInitial extends MateriDetailState {}

class MateriDetailLoading extends MateriDetailState {}

class MateriDetailLoaded extends MateriDetailState {
  final MateriVideo materi;

  MateriDetailLoaded(this.materi);
}

class MateriDetailError extends MateriDetailState {
  final String message;

  MateriDetailError(this.message);
}
