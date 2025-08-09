import '../../domain/entities/auth_credentials.dart';

class AuthCredentialModel extends AuthCredentials {
  const AuthCredentialModel({required String email, required String password})
    : super(email: email, password: password);

  factory AuthCredentialModel.fromJson(Map<String, dynamic> json) {
    return AuthCredentialModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
