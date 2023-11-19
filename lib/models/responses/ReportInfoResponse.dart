import 'dart:convert';

import 'package:todo_calendar_client/models/enums/ReportType.dart';
import 'package:todo_calendar_client/models/responses/ReportDescriptionResult.dart';

class ReportInfoResponse {

  final String reportType;
  final String beginMoment;
  final String endMoment;
  final ReportDescriptionResult reportContent;

  ReportInfoResponse({
    required this.reportType,
    required this.beginMoment,
    required this.endMoment,
    required this.reportContent
  });

  factory ReportInfoResponse.fromJson(Map <String, dynamic> json) {
    return ReportInfoResponse(
        beginMoment: json['begin_moment'],
        endMoment: json['end_moment'],
        reportType: json['report_type'],
        reportContent: json['report_content']
    );
  }
}