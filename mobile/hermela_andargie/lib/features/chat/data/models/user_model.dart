import '../../domain/entities/chat_user.dart';

class UserModel extends ChatUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '') as String;
    final name = (json['name'] ?? '') as String;
    final email = (json['email'] ?? '') as String;
    return UserModel(id: id, name: name, email: email);
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}
