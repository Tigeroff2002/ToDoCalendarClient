import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/EnumAliaser.dart';
import 'package:todo_calendar_client/models/enums/DecisionType.dart';
import 'package:todo_calendar_client/models/enums/EventType.dart';
import 'package:todo_calendar_client/models/enums/GroupType.dart';
import 'package:todo_calendar_client/models/requests/UserInfoRequestModel.dart';
import 'dart:convert';
import 'package:todo_calendar_client/models/responses/EventInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/GroupInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/ReportInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/ShortUserInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/TaskInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/UserInfoWithDecisionResponse.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/GetResponse.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';

import 'models/enums/EventStatus.dart';
import 'models/responses/additional_responces/ResponseWithToken.dart';

class EventsListPageWidget extends StatefulWidget {

  @override
  EventsListPageState createState() => EventsListPageState();
}

class EventsListPageState extends State<EventsListPageWidget> {

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final uri = 'http://localhost:5201/users/get_info';
  final headers = {'Content-Type': 'application/json'};
  bool isColor = false;

  final EnumAliaser aliaser = new EnumAliaser();

  List<EventInfoResponse> eventsList = [];

  Future<void> getUserInfo() async {

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null){
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new UserInfoRequestModel(userId: userId, token: token);
      var requestMap = model.toJson();

      var url = Uri.parse(uri);
      final body = jsonEncode(requestMap);

      final response = await http.post(url, headers: headers, body: body);

      var jsonData = jsonDecode(response.body);
      var responseContent = GetResponse.fromJson(jsonData);

      if (responseContent.result) {
        var userRequestedInfo = responseContent.requestedInfo.toString();

        var data = jsonDecode(userRequestedInfo);
        var userEvents = data['user_events'];

        var caption = "New december olimpiad discussion";
        var description = "Discussion about ICPC decemper tour olimpiad";
        var start = new DateTime(2023, 11, 17, 12, 0, 0);
        var duration = "00:30:00";
        var eventType = EventType.OneToOne;
        var eventStatus = EventStatus.NotStarted;

        var manager = new ShortUserInfoResponse(
            userName: "userName",
            userEmail: "userEmail",
            phoneNumber: "phoneNumber");

        List<ShortUserInfoResponse> participants = [manager];

        var group = new GroupInfoResponse(
            groupName: "groupName",
            groupType: GroupType.Educational,
            participants: participants);

        var userWithDecision = new UserInfoWithDecisionResponse(
            userName: "userName",
            userEmail: "userEmail",
            phoneNumber: "phoneNumber",
            decisionType: DecisionType.Apply);

        List<UserInfoWithDecisionResponse> guests = [userWithDecision];

        var event = new EventInfoResponse(
            caption: caption,
            description: description,
            start: start,
            duration: duration,
            eventType: eventType,
            eventStatus: eventStatus,
            manager: manager,
            group: group,
            guests: guests);

        List<EventInfoResponse> events = [event, event];

        /*
        var fetchedEvents =
          List<EventInfoResponse>
              .from(userEvents.map(
                  (data) => EventInfoResponse.fromJson(data)));
        */

        setState(() {
          eventsList = events;
        });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Список мероприятий'),
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
        body: ListView.builder(
          itemCount: eventsList.length,
          itemBuilder: (context, index) {
            final data = eventsList[index];
            return Card(
              color: isColor ? Colors.red : Colors.teal,
              elevation: 15,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isColor = !isColor;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Название мероприятия: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        utf8.decode(data.caption.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Описание мероприятия: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        utf8.decode(data.description.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Время начала мероприятия: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data.start.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Продолжительность мероприятия: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data.duration.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Тип события: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        aliaser.GetAlias(data.eventType),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Статус события: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        aliaser.GetAlias(data.eventStatus),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Название группы: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data.group.groupName,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Перейти к мероприятию'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}