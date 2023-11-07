import 'dart:convert';

import 'package:todo_calendar_client/models/enums/DecisionType.dart';
import 'package:todo_calendar_client/models/responses/ShortUserInfoResponse.dart';

class UserInfoWithDecisionResponse extends ShortUserInfoResponse{

  final DecisionType decisionType;

  UserInfoWithDecisionResponse({
    required String userName,
    required String userEmail,
    required String phoneNumber,
    required this.decisionType
  })
    : super(
      userName: userName,
      userEmail: userEmail,
      phoneNumber: phoneNumber
    );

  factory UserInfoWithDecisionResponse.fromJson(Map <String, dynamic> json) {
    return UserInfoWithDecisionResponse(
        userName: json['user_name'],
        userEmail: json['user_email'],
        phoneNumber: json['phone_number'],
        decisionType: json['decision_type']
    );
  }
}