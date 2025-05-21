import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_avatar_event.dart';
import 'update_avatar_state.dart';
import '../../repositories/auth_repository.dart';

class UpdateAvatarBloc extends Bloc<UpdateAvatarEvent, UpdateAvatarState> {
  final AuthRepository authRepository;

  UpdateAvatarBloc(this.authRepository) : super(UpdateAvatarInitial()) {
    on<SubmitAvatar>((event, emit) async {
      emit(UpdateAvatarLoading());
      try {
        await authRepository.updateAvatar(event.avatar);
        emit(UpdateAvatarSuccess());
      } catch (e) {
        emit(UpdateAvatarFailure(e.toString()));
      }
    });
  }
}
