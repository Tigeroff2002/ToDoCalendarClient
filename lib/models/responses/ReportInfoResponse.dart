class ReportInfoResponse {

  final String creationTime;
  final String beginMoment;
  final String endMoment;
  final String reportType;
  final String content;

  ReportInfoResponse({
    required this.reportType,
    required this.creationTime,
    required this.beginMoment,
    required this.endMoment,
    required this.content
  });

  factory ReportInfoResponse.fromJson(Map <String, dynamic> json) {
    return ReportInfoResponse(
        creationTime: json['creation_time'],
        beginMoment: json['begin_moment'],
        endMoment: json['end_moment'],
        reportType: json['report_type'],
        content: json['content']
    );
  }
}