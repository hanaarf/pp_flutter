import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/forgotPw/forgot_pw_event.dart';
import 'package:pp_flutter/blocs/forgotPw/forgot_pw_state.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc(this.authRepository) : super(ForgotPasswordInitial()) {
    on<SendResetPasswordEmailEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await authRepository.sendResetPasswordEmail(event.email);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });
  }
}
