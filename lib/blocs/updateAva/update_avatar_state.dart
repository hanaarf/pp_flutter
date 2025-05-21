abstract class UpdateAvatarState {}

class UpdateAvatarInitial extends UpdateAvatarState {}
class UpdateAvatarLoading extends UpdateAvatarState {}
class UpdateAvatarSuccess extends UpdateAvatarState {}
class UpdateAvatarFailure extends UpdateAvatarState {
  final String error;
  UpdateAvatarFailure(this.error);
}
