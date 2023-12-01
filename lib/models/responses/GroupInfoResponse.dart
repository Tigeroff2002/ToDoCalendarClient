import 'dart:convert';

import 'package:todo_calendar_client/models/enums/GroupType.dart';
import 'package:todo_calendar_client/models/responses/ShortUserInfoResponse.dart';

class GroupInfoResponse {

  final int groupId;
  final String groupName;
  final String groupType;
  //final List<ShortUserInfoResponse> participants;

  GroupInfoResponse({
    required this.groupId,
    required this.groupName,
    required this.groupType,
    //required this.participants
  });

  factory GroupInfoResponse.fromJson(Map <String, dynamic> json) {
    return GroupInfoResponse(
        groupId: json['group_id'],
        groupName: json['group_name'],
        groupType: json['group_type'],
        //participants: json['participants']
    );
  }
}