import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_calendar_client/EnumAliaser.dart';
import 'package:todo_calendar_client/models/EventAppointment.dart';
import 'package:todo_calendar_client/models/MeetingDataSource.dart';
import 'package:todo_calendar_client/models/requests/GroupParticipantCalendarRequest.dart';
import 'package:todo_calendar_client/models/requests/UserInfoRequestModel.dart';
import 'dart:convert';
import 'package:todo_calendar_client/models/responses/EventInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/GetResponse.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';
import 'models/responses/additional_responces/ResponseWithToken.dart';

class ParticipantCalendarPageWidget extends StatefulWidget {

  final int groupId;
  final int participantId;

  ParticipantCalendarPageWidget(
      {
        required this.groupId,
        required this.participantId
      });

  @override
  ParticipantCalendarPageState createState() =>
      new ParticipantCalendarPageState(groupId: groupId, participantId: participantId);
}

class ParticipantCalendarPageState extends State<ParticipantCalendarPageWidget> {

  @override
  void initState() {
    super.initState();
    getParticipantCalendarInfo();
  }

  final int groupId;
  final int participantId;

  ParticipantCalendarPageState(
      {
        required this.groupId,
        required this.participantId
      });

  final uri = 'http://127.0.0.1:5201/groups/get_participant_calendar';
  final headers = {'Content-Type': 'application/json'};
  bool isColor = false;

  final EnumAliaser aliaser = new EnumAliaser();

  List<EventInfoResponse> eventsList = [];

  Future<void> getParticipantCalendarInfo() async {

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null){
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new GroupParticipantCalendarRequest(
          userId: userId,
          token: token,
          groupId: groupId,
          participantId: participantId);

      var requestMap = model.toJson();

      var url = Uri.parse(uri);
      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        var jsonData = jsonDecode(response.body);
        var responseContent = GetResponse.fromJson(jsonData);

        if (responseContent.result) {
          var userRequestedInfo = responseContent.requestedInfo.toString();

          var data = jsonDecode(userRequestedInfo);
          var userEvents = data['participant_events'];

          var fetchedEvents =
          List<EventInfoResponse>
              .from(userEvents.map(
                  (data) => EventInfoResponse.fromJson(data)));

          setState(() {
            eventsList = fetchedEvents;
          });
        }
      }
      catch (e) {
        if (e is SocketException) {
          //treat SocketException
          print("Socket exception: ${e.toString()}");
        }
        else if (e is TimeoutException) {
          //treat TimeoutException
          print("Timeout exception: ${e.toString()}");
        }
        else
          print("Unhandled exception: ${e.toString()}");
      }
    }
    else {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка!'),
            content:
            Text(
                'Произошла ошибка при получении'
                    ' полной информации о пользователе!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  List<Appointment> getAppointments(List<EventInfoResponse> fetchedEvents){
    MaterialColor color = Colors.blue;

    List<EventAppointment> meetings =
    List.from(
        fetchedEvents.map((data) =>
        new EventAppointment(
            data.start,
            data.duration,
            data.caption)));

    List<Appointment> appointments =
    List.from(
        meetings.map((data) =>
        new Appointment(
            startTime: data.startTime,
            endTime: data.endTime,
            subject: data.subject,
            color: color)));

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Календарь мероприятий участника группы'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserPage()),);
            },
          ),
        ),
        body: SfCalendar(
          view: CalendarView.day,
          firstDayOfWeek: 1,
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now(),
          dataSource: MeetingDataSource(getAppointments(eventsList)),
        ),
      ),
    );
  }
}
