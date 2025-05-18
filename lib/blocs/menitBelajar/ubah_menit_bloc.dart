import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_event.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_state.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class UbahMenitBloc extends Bloc<UbahMenitEvent, UbahMenitState> {
  final AuthRepository repository;

  UbahMenitBloc(this.repository) : super(UbahMenitInitial()) {
    on<SubmitUbahMenit>((event, emit) async {
      emit(UbahMenitLoading());
      try {
        await repository.updateMenitBelajar(event.menit);
        emit(UbahMenitSuccess());
      } catch (e) {
        emit(UbahMenitFailure(e.toString()));
      }
    });
  }
}
