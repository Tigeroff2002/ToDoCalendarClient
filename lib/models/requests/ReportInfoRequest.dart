import 'package:todo_calendar_client/models/requests/RequestWithToken.dart';
import 'dart:convert';

class ReportInfoRequest extends RequestWithToken{

  final int reportId;

  ReportInfoRequest({
    required int userId,
    required String token,
    required this.reportId
  })
      : super(userId: userId, token: token);

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'report_id': reportId
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}