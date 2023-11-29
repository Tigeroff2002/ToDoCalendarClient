import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/EnumAliaser.dart';
import 'package:todo_calendar_client/models/requests/UserInfoRequestModel.dart';
import 'dart:convert';
import 'package:todo_calendar_client/models/responses/additional_responces/GetResponse.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';
import 'models/responses/TaskInfoResponse.dart';
import 'models/responses/additional_responces/ResponseWithToken.dart';

class TasksListPageWidget extends StatefulWidget {

  @override
  TasksListPageState createState() => TasksListPageState();
}

class TasksListPageState extends State<TasksListPageWidget> {

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final uri = 'http://127.0.0.1:5201/users/get_info';
  final headers = {'Content-Type': 'application/json'};
  bool isColor = false;

  final EnumAliaser aliaser = new EnumAliaser();

  List<TaskInfoResponse> tasksList = [];

  Future<void> getUserInfo() async {
    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new UserInfoRequestModel(userId: userId, token: token);
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
          var userTasks = data['user_tasks'];

          var fetchedTasks =
          List<TaskInfoResponse>
              .from(userTasks.map(
                  (data) => TaskInfoResponse.fromJson(data)));

          setState(() {
            tasksList = fetchedTasks;
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
              builder: (context) =>
                  AlertDialog(
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
          title: Text('Список задач на реализацию'),
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
          itemCount: tasksList.length,
          itemBuilder: (context, index) {
            final data = tasksList[index];
            return Card(
              color: isColor ? Colors.cyan : Colors.greenAccent,
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
                        'Название задачи: ',
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
                        'Описание задачи: ',
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
                        'Тип задачи: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        aliaser.GetAlias(
                            aliaser.getTaskTypeEnumValue(data.taskType)),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Текущий статус задачи: ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        aliaser.GetAlias(
                            aliaser.getTaskStatusEnumValue(data.taskStatus)),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8)
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