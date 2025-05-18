import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_event.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_state.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class UbahProfileBloc extends Bloc<UbahProfileEvent, UbahProfileState> {
  final AuthRepository repository;

  UbahProfileBloc(this.repository) : super(UbahProfileInitial()) {
    on<SubmitUbahProfile>((event, emit) async {
      emit(UbahProfileLoading());
      try {
        await repository.updateProfile(
          name: event.name,
          jenjangId: event.jenjangId,
          kelasId: event.kelasId,
        );
        emit(UbahProfileSuccess());
      } catch (e) {
        emit(UbahProfileFailure(e.toString()));
      }
    });
  }
}
