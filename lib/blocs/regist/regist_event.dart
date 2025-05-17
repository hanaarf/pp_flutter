abstract class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequested({required this.name, required this.email, required this.password, required this.confirmPassword});
}
