import 'package:todo_calendar_client/models/responses/ReportDescriptionResult.dart';
import 'package:todo_calendar_client/models/responses/TaskInfoResponse.dart';

class ReportTaskDescriptionResult extends ReportDescriptionResult{

  final List<TaskInfoResponse> userTasks;

  ReportTaskDescriptionResult({
    required String creationTime,
    required this.userTasks
  })
      : super(creationTime: creationTime);

  factory ReportTaskDescriptionResult.fromJson(Map <String, dynamic> json) {
    return ReportTaskDescriptionResult(
        creationTime: json['creation_time'],
        userTasks: json['user_tasks']
    );
  }
}