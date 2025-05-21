abstract class UpdateAvatarEvent {}

class SubmitAvatar extends UpdateAvatarEvent {
  final String avatar;
  SubmitAvatar(this.avatar);
}
