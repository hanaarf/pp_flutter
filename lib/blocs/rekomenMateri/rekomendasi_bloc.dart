import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/rekomenMateri/rekomendasi_event.dart';
import 'package:pp_flutter/blocs/rekomenMateri/rekomendasi_state.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';

class RekomendasiBloc extends Bloc<RekomendasiEvent, RekomendasiState> {
  final MateriRepository repository;

  RekomendasiBloc(this.repository) : super(RekomendasiInitial()) {
    on<LoadRekomendasiMateri>((event, emit) async {
      emit(RekomendasiLoading());
      try {
        final data = await repository.getRekomendasiMateri();
        emit(RekomendasiLoaded(data));
      } catch (e) {
        emit(RekomendasiError(e.toString()));
      }
    });
  }
}
