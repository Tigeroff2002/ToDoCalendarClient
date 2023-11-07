import 'dart:convert';

class UserRegisterModel {

  final String email;
  final String name;
  final String password;
  final String phoneNumber;

  UserRegisterModel({
    required this.email,
    required this.name,
    required this.password,
    required this.phoneNumber
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'phone_number': phoneNumber
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}