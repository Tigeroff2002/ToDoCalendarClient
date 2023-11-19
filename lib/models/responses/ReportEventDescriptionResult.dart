import 'package:todo_calendar_client/models/responses/EventInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/ReportDescriptionResult.dart';

class ReportEventDescriptionResult extends ReportDescriptionResult{

  final List<EventInfoResponse> userEvents;

  ReportEventDescriptionResult({
    required String creationTime,
    required this.userEvents
  })
    : super(creationTime: creationTime);


  factory ReportEventDescriptionResult.fromJson(Map <String, dynamic> json) {
    return ReportEventDescriptionResult(
      creationTime: json['creation_time'],
      userEvents: json['user_events']
    );
  }
}