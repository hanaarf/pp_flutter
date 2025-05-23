import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_event.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_state.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class LatihanSoalBloc extends Bloc<LatihanSoalEvent, LatihanSoalState> {
  final SiswaRepositori repository;

  LatihanSoalBloc(this.repository) : super(LatihanSoalInitial()) {
    on<FetchLatihanSoal>((event, emit) async {
      emit(LatihanSoalLoading());
      try {
        final soal = await repository.getLatihanSoal(event.materiId);
        emit(LatihanSoalLoaded(soal));
      } catch (e) {
        emit(LatihanSoalError(e.toString()));
      }
    });
  }
}
