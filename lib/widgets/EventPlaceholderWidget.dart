import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/additional_page.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_info_map.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewEventModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

import '../models/responses/additional_responces/ResponseWithToken.dart';

class EventPlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;

  final int groupId = 10;
  late String token;

  final TextEditingController eventCaptionController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController scheduledStartController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController eventStatusController = TextEditingController();

  EventPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index
      });

  Future<void> addNewEvent(BuildContext context) async
  {
    String caption = eventCaptionController.text;
    String description = eventDescriptionController.text;
    String scheduledStart = selectedBeginDateTime.toString();

    int durationMs =
      selectedEndDateTime.millisecondsSinceEpoch
          > selectedBeginDateTime.millisecondsSinceEpoch
      ? selectedEndDateTime.difference(selectedBeginDateTime).inMilliseconds
      : DateTime(0, 0, 0, 0, 30, 0).millisecondsSinceEpoch;

    DateTime durationInDateTime = DateTime.fromMicrosecondsSinceEpoch(durationMs);

    var format = DateFormat('hh:mm:ss');

    var duration = format.format(durationInDateTime).toString();

    String eventType = eventTypeController.text;
    String eventStatus = eventStatusController.text;

    var guestIds = [2];

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null){
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new AddNewEventModel(
          userId: (userId),
          token: token,
          caption: caption,
          description: description,
          start: scheduledStart,
          duration: duration,
          eventType: eventType,
          eventStatus: eventStatus,
          groupId: groupId,
          guestIds: guestIds);

      var requestMap = model.toJson();

      final url = Uri.parse('http://localhost:5201/events/schedule_new');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(requestMap);
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200){

        var jsonData = jsonDecode(response.body);
        var responseContent = Response.fromJson(jsonData);
        if (responseContent.outInfo != null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(responseContent.outInfo.toString())
              )
          );
        }
      }
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Создание нового мероприятия не произошло!'),
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

    eventCaptionController.clear();
    eventDescriptionController.clear();
    scheduledStartController.clear();
    durationController.clear();
    eventTypeController.clear();
    eventStatusController.clear();
  }

  @override
  Widget build(BuildContext context) {

    selectedBeginDateTime = DateTime.now();
    selectedEndDateTime = DateTime.now();
    final eventTypes = ['None', 'Personal', 'OneToOne', 'StandUp', 'Meeting'];
    final eventStatuses = ['None', 'NotStarted', 'WithinReminderOffset', 'Live', 'Finished', 'Cancelled'];

    final beginHours = selectedBeginDateTime.hour.toString().padLeft(2, '0');
    final beginMinutes = selectedBeginDateTime.minute.toString().padLeft(2, '0');

    final showingBeginHours = (selectedBeginDateTime.hour + 1).toString().padLeft(2, '0');
    final showingBeginMinutes = 0.toString().padLeft(2, '0');

    final endHours = selectedEndDateTime.hour.toString().padLeft(2, '0');
    final endMinutes = selectedEndDateTime.minute.toString().padLeft(2, '0');

    final showingEndHours = (selectedEndDateTime.hour + 1).toString().padLeft(2, '0');
    final showingEndMinutes = 0.toString().padLeft(2, '0');

    Future<DateTime?> pickDate(DateTime selectedDateTime) => showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2023),
        lastDate: DateTime(2025)
    );

    Future<TimeOfDay?> pickTime(DateTime selectedDateTime) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: selectedDateTime.hour + 1,
            minute: 0));

    Future pickBeginDateTime() async {

      DateTime? date = await pickDate(selectedBeginDateTime);
      if (date == null) return;

      final time = await pickTime(selectedBeginDateTime);

      if (time == null) return;

      final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute
      );

      selectedBeginDateTime = newDateTime;
    }

    Future pickEndDateTime() async {

      DateTime? date = await pickDate(selectedEndDateTime);
      if (date == null) return;

      final time = await pickTime(selectedEndDateTime);

      if (time == null) return;

      final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute
      );

      selectedEndDateTime = newDateTime;
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            if(index == 0) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoMapPage()),);
                },
                child: Text('Перейти к вашему личному кабинету'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdditionalPageWidget()),);
                },
                child: Text('Страничка с картинками'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  MySharedPreferences mySharedPreferences = new MySharedPreferences();
                  mySharedPreferences.clearData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),);
                },
                child: Text('Выйти'),
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 16.0),
              TextField(
                controller: eventCaptionController,
                decoration: InputDecoration(
                  labelText: 'Наименование мероприятия:',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: eventDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание меропрития:',
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Время начала мероприятия',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6.0),
              ElevatedButton(
                child: Text(
                    '${selectedBeginDateTime.year}'
                        '/${selectedBeginDateTime.month}'
                        '/${selectedBeginDateTime.day}'
                        ' $showingBeginHours'
                        ':$showingBeginMinutes'),
                onPressed: () async {
                  await pickBeginDateTime();
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Время окончания мероприятия',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6.0),
              ElevatedButton(
                child: Text(
                    '${selectedEndDateTime.year}'
                        '/${selectedEndDateTime.month}'
                        '/${selectedEndDateTime.day}'
                        ' $showingEndHours'
                        ':$showingEndMinutes'),
                onPressed: () async {
                  await pickEndDateTime();
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Тип мероприятия',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  items: eventTypes.map((String type){
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type));
                  }).toList(),
                  onChanged: (String? newType){
                    selectedEventType = newType.toString();
                  }),
              SizedBox(height: 12.0),
              Text(
                'Статус мероприятия',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  items: eventStatuses.map((String status){
                    return DropdownMenuItem(
                        value: status,
                        child: Text(status));
                  }).toList(),
                  onChanged: (String? newStatus){
                    selectedEventStatus = newStatus.toString();
                  }),
            ],
            if(index == 1) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addNewEvent(context);
                },
                child: Text('Создать новое мероприятие'),
              ),
            ],
          ]
      ),
    )
    );
  }

  String selectedEventType = "None";
  String selectedEventStatus = "None";

  DateTime selectedBeginDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();
}