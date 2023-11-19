class ReportDescriptionResult{

  final String creationTime;

  ReportDescriptionResult({
    required this.creationTime
  });

  factory ReportDescriptionResult.fromJson(Map <String, dynamic> json) {
    return ReportDescriptionResult(
        creationTime: json['creation_time']
    );
  }
}