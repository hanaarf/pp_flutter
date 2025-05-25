abstract class ForgotPasswordEvent {}

class SendResetPasswordEmailEvent extends ForgotPasswordEvent {
  final String email;
  SendResetPasswordEmailEvent(this.email);
}
