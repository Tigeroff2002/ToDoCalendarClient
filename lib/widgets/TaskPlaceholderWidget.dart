import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/events_calendar.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewTaskModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

class TaskPlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;

  final int userId;
  final String token;

  final TextEditingController taskCaptionController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  final TextEditingController taskTypeController = TextEditingController();
  final TextEditingController taskStatusController = TextEditingController();

  TaskPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index,
        required this.userId,
        required this.token
      });

  Future<void> addNewTask(BuildContext context) async
  {
    String caption = taskCaptionController.text;
    String description = taskStatusController.text;
    String taskType = taskTypeController.text;
    String taskStatus = taskStatusController.text;

    var implementerId = 3;

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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventsCalendarPage()),);
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
              SizedBox(height: 8.0),
              TextField(
                controller: taskCaptionController,
                decoration: InputDecoration(
                  labelText: 'Наименование задачи: ',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: taskDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание задачи: ',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: taskTypeController,
                decoration: InputDecoration(
                  labelText: 'Тип задачи: ',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: taskStatusController,
                decoration: InputDecoration(
                  labelText: 'Текущий статус задачи: ',
                ),
              ),
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
}