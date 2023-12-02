import 'package:todo_calendar_client/models/responses/additional_responces/ResponseWithToken.dart';

class ResponseWithTokenAndName extends ResponseWithToken{

  final String? userName;

  ResponseWithTokenAndName({
    required bool result,
    String? outInfo,
    required int userId,
    String? token,
    this.userName
    }) :super(
      result: result,
      outInfo: outInfo,
      userId: userId,
      token: token);

  factory ResponseWithTokenAndName.fromJson(Map <String, dynamic> json) {
    return ResponseWithTokenAndName(
        result: json['result'],
        outInfo: json['out_info'],
        userId: json['user_id'],
        token: json['token'],
        userName: json['user_name']
    );
  }
}