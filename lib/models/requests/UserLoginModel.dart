import 'dart:convert';

class UserLoginModel {

  final String email;
  final String password;

  UserLoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}