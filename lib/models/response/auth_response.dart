class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}

class RegisterResponse {
  final Map<String, dynamic> user;
  final String token;

  RegisterResponse({required this.user, required this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: json['user'],
      token: json['token'],
    );
  }
}
