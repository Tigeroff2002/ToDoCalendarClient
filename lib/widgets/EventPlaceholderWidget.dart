import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    String scheduledStart = scheduledStartController.text;
    String duration = durationController.text;
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

      var jsonData = jsonDecode(response.body);
      var responseContent = Response.fromJson(jsonData);
      if (responseContent.result){
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
    return Padding(
      padding: EdgeInsets.all(16.0),
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
                  MySharedPreferences mySharedPreferences = new MySharedPreferences();
                  mySharedPreferences.clearData();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
                },
                child: Text('Выйти'),
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: eventCaptionController,
                decoration: InputDecoration(
                  labelText: 'Наименование мероприятия:',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: eventDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание меропрития:',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: scheduledStartController,
                decoration: InputDecoration(
                  labelText: 'Время начала мероприятия',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: eventTypeController,
                decoration: InputDecoration(
                  labelText: 'Тип мероприятия',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: eventStatusController,
                decoration: InputDecoration(
                  labelText: 'Статус мероприятия',
                ),
              ),
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
    );
  }
}