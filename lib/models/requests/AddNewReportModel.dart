import 'package:todo_calendar_client/models/enums/ReportType.dart';
import 'dart:convert';
import 'RequestWithToken.dart';

class AddNewReportModel extends RequestWithToken {

  final ReportType reportType;
  final DateTime beginMoment;
  final DateTime endMoment;

  AddNewReportModel({
    required int userId,
    required String token,
    required this.reportType,
    required this.beginMoment,
    required this.endMoment
  })
      : super(userId: userId, token: token);

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'report_type': reportType,
      'begin_moment': beginMoment,
      'end_moment': endMoment
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}