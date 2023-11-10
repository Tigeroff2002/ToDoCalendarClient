import 'dart:convert';

import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

class ResponseWithToken extends Response{

  final String? token;

  ResponseWithToken({
    required bool result,
    String? outInfo,
    this.token
  }) :super(result: result, outInfo: outInfo);

  factory ResponseWithToken.fromJson(Map <String, dynamic> json) {
    return ResponseWithToken(
        result: json['result'],
        outInfo: json['out_info'],
        token: json['token']
    );
  }
}