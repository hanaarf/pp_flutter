// ignore: file_names
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_state.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class LatihanMateriBloc extends Bloc<LatihanMateriEvent, LatihanMateriState> {
  final SiswaRepositori repository;

  LatihanMateriBloc(this.repository) : super(LatihanMateriInitial()) {
    on<FetchLatihanMateri>((event, emit) async {
      emit(LatihanMateriLoading());
      try {
        final materi = await repository.getLatihanMateri();
        emit(LatihanMateriLoaded(materi));
      } catch (e) {
        emit(LatihanMateriError(e.toString()));
      }
    });
  }
}
