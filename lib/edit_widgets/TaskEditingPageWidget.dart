import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/models/requests/AddNewTaskModel.dart';
import 'package:todo_calendar_client/models/requests/EditExistingTaskModel.dart';
import 'package:todo_calendar_client/models/requests/TaskInfoRequest.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';
import 'package:todo_calendar_client/tasks_list_page.dart';
import '../models/responses/additional_responces/GetResponse.dart';
import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class TaskEditingPageWidget extends StatefulWidget{

  final int taskId;

  TaskEditingPageWidget({required this.taskId});

  @override
  TaskEditingPageState createState(){
    return new TaskEditingPageState(taskId: taskId);
  }
}

class TaskEditingPageState extends State<TaskEditingPageWidget> {

  final int taskId;

  TaskEditingPageState({required this.taskId});

  final TextEditingController taskCaptionController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  bool isCaptionValidated = true;
  bool isDescriptionValidated = true;

  Future<void> getExistedTask(BuildContext context) async
  {
    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new TaskInfoRequest(userId: userId, token: token, taskId: taskId);

      var requestMap = model.toJson();

      final url = Uri.parse('http://127.0.0.1:5201/tasks/get_task_info');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        var jsonData = jsonDecode(response.body);
        var responseContent = GetResponse.fromJson(jsonData);

        if (responseContent.result) {
            var userRequestedInfo = responseContent.requestedInfo.toString();

            print(userRequestedInfo);

            setState(() {
              existedCaption = 'Старое название';
              existedDescription = 'Старое описание';
              taskCaptionController.text = existedCaption;
              taskDescriptionController.text = existedDescription;
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Получение инфы о задаче не удалось!'),
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


  Future<void> editCurrentTask(BuildContext context) async
  {
    String caption = taskCaptionController.text;
    String description = taskDescriptionController.text;
    String taskType = selectedTaskType.toString();
    String taskStatus = selectedTaskStatus.toString();

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var implementerId = 3;

      var model = new EditExistingTaskModel(
          userId: userId,
          token: token,
          caption: caption,
          description: description,
          taskType: taskType,
          taskStatus: taskStatus,
          implementerId: implementerId,
          taskId: taskId);

      var requestMap = model.toJson();

      final url = Uri.parse('http://127.0.0.1:5201/tasks/update_task_params');
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Изменение существующей задачи не удалось!'),
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

    setState(() {
      getExistedTask(context);
    });

    var taskTypes = ['None', 'AbstractGoal', 'MeetingPresense', 'JobComplete'];
    var taskStatuses = ['None', 'ToDo', 'InProgress', 'Review', 'Done'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Страничка редактирования задачи'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TasksListPageWidget()),);
            },
          ),
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Изменение существующей задачи',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              SizedBox(height: 16.0),
              TextField(
                controller: taskCaptionController,
                decoration: InputDecoration(
                    labelText: 'Наименование задачи: ',
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.deepOrange
                    ),
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
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.deepOrange
                    ),
                    errorText: !isDescriptionValidated
                        ? 'Описание мероприятия не может быть пустым'
                        : null
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Тип задачи',
                style: TextStyle(fontSize: 16, color: Colors.deepOrange),
              ),
              SizedBox(height: 4.0),
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
                style: TextStyle(fontSize: 16, color : Colors.deepOrange),
              ),
              SizedBox(height: 4.0),
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
                  minimumSize: Size(250, 100),
                ),
                onPressed: () async {
                  setState(() {
                    isCaptionValidated = !taskCaptionController.text.isEmpty;
                    isDescriptionValidated = !taskDescriptionController.text.isEmpty;

                    if (isCaptionValidated && isDescriptionValidated){
                      editCurrentTask(context);
                    }
                  });
                },
                child: Text('Изменить текущую задачу'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String selectedTaskType = 'None';
  String selectedTaskStatus = 'None';

  String existedCaption = '';
  String existedDescription = '';
  String existedTaskType = 'None';
  String existedTaskStatus = 'None';
}