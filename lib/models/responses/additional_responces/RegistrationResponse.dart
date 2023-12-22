import 'dart:convert';

import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

class RegistrationResponse extends Response{

  int? userId;
  final String? token;
  final String registrationCase;

  RegistrationResponse({
    required bool result,
    String? outInfo,
    this.userId,
    this.token,
    required this.registrationCase
  }) :super(result: result, outInfo: outInfo);

  factory RegistrationResponse.fromJson(Map <String, dynamic> json) {
    return RegistrationResponse(
        result: json['result'],
        outInfo: json['out_info'],
        userId: json['user_id'],
        token: json['token'],
        registrationCase: json['case']
    );
  }
}