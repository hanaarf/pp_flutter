import 'package:flutter_bloc/flutter_bloc.dart';
import 'ulasan_event.dart';
import 'ulasan_state.dart';
import 'package:pp_flutter/repositories/ulasan_repository.dart';

class UlasanBloc extends Bloc<UlasanEvent, UlasanState> {
  final UlasanRepository repository;

  UlasanBloc(this.repository) : super(UlasanInitial()) {
    on<KirimUlasanEvent>((event, emit) async {
      emit(UlasanLoading());
      try {
        await repository.kirimUlasan(event.deskripsi);
        emit(UlasanSuccess());
      } catch (e) {
        emit(UlasanFailure(e.toString()));
      }
    });
  }
}
