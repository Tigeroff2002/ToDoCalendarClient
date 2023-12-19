import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/models/requests/AddNewTaskModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';
import '../GlobalEndpoints.dart';
import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class TaskPlaceholderWidget extends StatefulWidget{

  final Color color;
  final String text;
  final int index;

  TaskPlaceholderWidget({required this.color, required this.text, required this.index});

  @override
  TaskPlaceholderState createState(){
    return new TaskPlaceholderState(color: color, text: text, index: index);
  }
}

class TaskPlaceholderState extends State<TaskPlaceholderWidget> {
  final Color color;
  final String text;
  final int index;

  final TextEditingController taskCaptionController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  bool isCaptionValidated = true;
  bool isDescriptionValidated = true;

  TaskPlaceholderState(
      {
        required this.color,
        required this.text,
        required this.index
      });

  Future<void> addNewTask(BuildContext context) async
  {
    String caption = taskCaptionController.text;
    String description = taskDescriptionController.text;
    String taskType = selectedTaskType.toString();
    String taskStatus = selectedTaskStatus.toString();

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

      var uris = GlobalEndpoints();

      bool isMobile = Theme.of(context).platform == TargetPlatform.android;

      var currentUri = isMobile ? uris.mobileUri : uris.webUri;

      var requestString = '/tasks/create';

      var currentPort = isMobile ? uris.currentMobilePort : uris.currentWebPort;

      final url = Uri.parse(currentUri + currentPort + requestString);

      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(requestMap);

      try {
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

        taskCaptionController.clear();
        taskDescriptionController.clear();
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
  }

  @override
  Widget build(BuildContext context) {

    var taskTypes = ['None', 'AbstractGoal', 'MeetingPresense', 'JobComplete'];
    var taskStatuses = ['None', 'ToDo', 'InProgress', 'Review', 'Done'];

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
                  SizedBox(height: 16.0),
                  TextField(
                    controller: taskCaptionController,
                    decoration: InputDecoration(
                        labelText: 'Наименование задачи: ',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.deepPurple),
                        errorText: !isCaptionValidated
                            ? 'Название задачи не может быть пустым'
                            : null
                    ),
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    controller: taskDescriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Описание задачи: ',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.deepPurple),
                        errorText: !isDescriptionValidated
                            ? 'Описание мероприятия не может быть пустым'
                            : null
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Тип задачи',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButton(
                      value: selectedTaskType,
                      items: taskTypes.map((String type){
                        return DropdownMenuItem(
                            value: type,
                            child: Text(type));
                      }).toList(),
                      onChanged: (String? newType){
                        setState(() {
                          selectedTaskType = newType.toString();
                        });
                      }),
                  SizedBox(height: 12.0),
                  Text(
                    'Статус задачи',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButton(
                      value: selectedTaskStatus,
                      items: taskStatuses.map((String status){
                        return DropdownMenuItem(
                            value: status,
                            child: Text(status));
                      }).toList(),
                      onChanged: (String? newStatus){
                        setState(() {
                          selectedTaskStatus = newStatus.toString();
                        });
                      }),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor : Colors.white,
                        shadowColor: Colors.cyan,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minimumSize: Size(150, 50)),
                    onPressed: () async {
                      setState(() {
                        isCaptionValidated = !taskCaptionController.text.isEmpty;
                        isDescriptionValidated = !taskDescriptionController.text.isEmpty;

                        if (isCaptionValidated && isDescriptionValidated){
                          addNewTask(context);
                        }
                      });
                    },
                    child: Text('Создать новую задачу'),
                  ),
                ],
          ),
      )
    );
  }

  String selectedTaskType = 'None';
  String selectedTaskStatus = 'None';
}