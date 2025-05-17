import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/models/request/register_request.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'regist_event.dart';
import 'regist_state.dart';

class RegistBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  RegistBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await authRepository.register(
          RegisterRequest(
            name: event.name,
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword,
          ),
        );

        // Simpan token ke secure storage
        await authRepository.saveToken(data.token);
        emit(AuthSuccess(token: data.token));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}
