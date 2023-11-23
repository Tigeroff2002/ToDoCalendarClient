import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/user_info_map.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewTaskModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class TaskPlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;

  final TextEditingController taskCaptionController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  final TextEditingController taskTypeController = TextEditingController();
  final TextEditingController taskStatusController = TextEditingController();

  TaskPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index
      });

  Future<void> addNewTask(BuildContext context) async
  {
    String caption = taskCaptionController.text;
    String description = taskStatusController.text;
    String taskType = taskTypeController.text;
    String taskStatus = taskStatusController.text;

    var implementerId = 3;

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new AddNewTaskModel(
          userId: (userId),
          token: token,
          caption: caption,
          description: description,
          taskType: taskType,
          taskStatus: taskStatus,
          implementerId: implementerId
      );

      var requestMap = model.toJson();

      final url = Uri.parse('http://localhost:5201/tasks/create');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(requestMap);
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {

        var jsonData = jsonDecode(response.body);
        var responseContent = Response.fromJson(jsonData);

        if (responseContent.outInfo != null) {
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
          content: Text('Создание новой задачи не произошло!'),
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

    taskCaptionController.clear();
    taskDescriptionController.clear();
    taskTypeController.clear();
    taskStatusController.clear();
  }

  @override
  Widget build(BuildContext context) {

    var taskTypes = ['None', 'AbstractGoal', 'MeetingPresense', 'JobComplete'];
    var taskStatuses = ['None', 'ToDo', 'InProgress', 'Review', 'Done'];

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if(index == 0) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoMapPage()),);
                },
                child: Text('Перейти к вашему календарю'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
                },
                child: Text('Выйти'),
              ),
            ],
            if(index == 3) ...[
              SizedBox(height: 12.0),
              TextField(
                controller: taskCaptionController,
                decoration: InputDecoration(
                  labelText: 'Наименование задачи: ',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: taskDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание задачи: ',
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Тип задачи',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  items: taskTypes.map((String type){
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type));
                  }).toList(),
                  onChanged: (String? newType){
                    selectedTaskType = newType.toString();
                  }),
              SizedBox(height: 12.0),
              Text(
                'Статус задачи',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  items: taskStatuses.map((String status){
                    return DropdownMenuItem(
                        value: status,
                        child: Text(status));
                  }).toList(),
                  onChanged: (String? newStatus){
                    selectedTaskStatus = newStatus.toString();
                  }),
            ],
            if(index == 3) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addNewTask(context);
                },
                child: Text('Создать новую задачу'),
              ),
            ],
          ]
      ),
    );
  }

  String selectedTaskType = 'None';
  String selectedTaskStatus = 'None';
}