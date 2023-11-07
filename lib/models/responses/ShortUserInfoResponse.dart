import 'dart:convert';

class ShortUserInfoResponse {

  final String userName;
  final String userEmail;
  final String phoneNumber;

  ShortUserInfoResponse({
    required this.userName,
    required this.userEmail,
    required this.phoneNumber
  });

  factory ShortUserInfoResponse.fromJson(Map <String, dynamic> json) {
    return ShortUserInfoResponse(
      userName: json['user_name'],
      userEmail: json['user_email'],
      phoneNumber: json['phone_number']
    );
  }
}