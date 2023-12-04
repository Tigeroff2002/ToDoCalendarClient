import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_calendar_client/EnumAliaser.dart';
import 'package:todo_calendar_client/models/EventAppointment.dart';
import 'package:todo_calendar_client/models/MeetingDataSource.dart';
import 'package:todo_calendar_client/models/requests/EventInfoRequest.dart';
import 'package:todo_calendar_client/models/requests/UserInfoRequestModel.dart';
import 'dart:convert';
import 'package:todo_calendar_client/models/responses/EventInfoResponse.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/GetResponse.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';
import 'models/responses/ShortUserInfoResponse.dart';
import 'models/responses/additional_responces/ResponseWithToken.dart';

import 'package:intl/intl.dart';

class EventsListPageWidget extends StatefulWidget {
  const EventsListPageWidget({super.key});


  @override
  EventsListPageState createState() => EventsListPageState();
}

class EventsListPageState extends State<EventsListPageWidget> {

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final userInfoUri = 'http://10.0.2.2:5201/users/get_info';
  final eventInfoUri = 'http://10.0.2.2:5201/events/get_event_info';

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

      var url = Uri.parse(userInfoUri);
      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        var jsonData = jsonDecode(response.body);
        var responseContent = GetResponse.fromJson(jsonData);

        if (responseContent.result) {
          var userRequestedInfo = responseContent.requestedInfo.toString();

          var data = jsonDecode(userRequestedInfo);
          var userEvents = data['user_events'];

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
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Ошибка!'),
              content: Text('Проблема с соединением к серверу!'),
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

  Future<UsersListsContent?> getCertainEventInfo(int eventId) async {

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null){
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new EventInfoRequest(userId: userId, token: token, eventId: eventId);
      var requestMap = model.toJson();

      var url = Uri.parse(eventInfoUri);
      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        var jsonData = jsonDecode(response.body);
        var responseContent = GetResponse.fromJson(jsonData);

        if (responseContent.result) {
          var userRequestedInfo = responseContent.requestedInfo.toString();
          print(userRequestedInfo);
          var rawBeginIndex = userRequestedInfo.indexOf('"guests"');
          var rawEndIndex = userRequestedInfo.indexOf(']}') + 2;

          var string = '{' + userRequestedInfo.substring(rawBeginIndex, rawEndIndex) + '}';

          var contentData = jsonDecode(string);

          var eventParticipants = contentData['guests'];

          var fetchedEventUsers =
          List<ShortUserInfoResponse>
              .from(eventParticipants.map(
                  (data) => ShortUserInfoResponse.fromJson(data)));

          rawBeginIndex = userRequestedInfo.indexOf('"participants"');
          rawEndIndex = userRequestedInfo.indexOf(']}') + 2;

          string = '{' + userRequestedInfo.substring(rawBeginIndex, rawEndIndex);

          contentData = jsonDecode(string);

          var groupUsers = contentData['participants'];

          var fetchedGroupUsers =
          List<ShortUserInfoResponse>
              .from(groupUsers.map(
                  (data) => ShortUserInfoResponse.fromJson(data)));

          List<ShortUserInfoResponse> remainingGroupUsers = [];

          fetchedGroupUsers.forEach((element) {
            if (!fetchedEventUsers.any(
                    (element1) =>
                      element1.userId == element.userId)){
              remainingGroupUsers.add(element);
            }
          });

          var content = new UsersListsContent(
              eventUsers: fetchedEventUsers,
              remainingGroupUsers: remainingGroupUsers);

          return content;
        }
      }
      catch (e) {
        if (e is SocketException) {
          //treat SocketException
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Ошибка!'),
              content: Text('Проблема с соединением к серверу!'),
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
                data.eventId,
                data.start,
                data.duration,
                data.caption)));

    List<Appointment> appointments =
        List.from(
          meetings.map((data) =>
            new Appointment(
                id: data.eventId,
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
          title: Text('Календарь мероприятий'),
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
          timeZone: 'Russian Standard Time',
          onTap: calendarTapped,
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.subject;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.startTime.add(Duration(hours: 3))).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.endTime.add(Duration(hours: 3))).toString();
      _eventId = appointmentDetails.id.toString();

      int eventId = int.parse(_eventId);

      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }

      setState(() {
        getCertainEventInfo(eventId).then((value) {
          UsersListsContent content = value!;

          var eventUsers = content.eventUsers;
          var groupUsers = content.remainingGroupUsers;

          var builder = StringBuffer();

          eventUsers.forEach((element) {
            builder.write(element.userName + ' (' + element.userEmail + ')\n');
          });

          certainEventUsersDescription = builder.toString();

          builder.clear();

          groupUsers.forEach((element) {
            builder.write(element.userName + ' (' + element.userEmail + ')\n');
          });

          certainEventUsersFromGroupDescription = builder.toString();

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Container(child: new Text('$_subjectText')),
                  content: Container(
                      height: 200,
                      width: 500,
                      child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Дата и время события:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(''),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '$_dateText',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(_timeDetails!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400, fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(''),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'Список участников события: \n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18)),
                                    SizedBox(height: 6.0)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      certainEventUsersDescription,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          color: Colors.lightGreen
                                      ))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(''),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'Можно еще пригласить: \n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18)),
                                    SizedBox(height: 6.0)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        certainEventUsersFromGroupDescription,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Colors.indigo
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          )
                      )
                  ),
                  actions: <Widget>[
                    new ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text('ОК'))
                  ],
                );
              });
        });
      });
    }
  }

  String _timeDetails = '';
  String _dateText = '';
  String _subjectText = '';
  String _startTimeText = '';
  String _endTimeText = '';
  String _eventId = '';

  String certainEventUsersDescription = '';
  String certainEventUsersFromGroupDescription = '';
}

class UsersListsContent{
  final List<ShortUserInfoResponse> eventUsers;
  final List<ShortUserInfoResponse> remainingGroupUsers;

  UsersListsContent(
      {
        required this.eventUsers,
        required this.remainingGroupUsers
      });
}


/* legacy code
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
                        aliaser.GetAlias(
                            aliaser.getEventTypeEnumValue(data.eventType)),
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
                        aliaser.GetAlias(
                            aliaser.getEventStatusEnumValue(data.eventStatus)),
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
       */