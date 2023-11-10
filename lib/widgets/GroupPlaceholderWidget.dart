import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/user_info_map.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewGroupModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

class GroupPlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;

  final int userId;
  final String token;

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupTypeController = TextEditingController();

  GroupPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index,
        required this.userId,
        required this.token
      });

  Future<void> addNewGroup(BuildContext context) async
  {
    String name = groupNameController.text;
    String groupType = groupTypeController.text;

    var participants = [2, 3];

    var model = new AddNewGroupModel(
        userId: (userId),
        token: token,
        groupName: name,
        groupType: groupType,
        participants: participants
      );

    var requestMap = model.toJson();

    final url = Uri.parse('http://localhost:5201/groups/create');
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
          content: Text('Создание новой группы не произошло!'),
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

    groupNameController.clear();
    groupTypeController.clear();
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserInfoMapPage()),);
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
            if(index == 2) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  labelText: 'Наименование группы:',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: groupTypeController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Тип группы:',
                ),
              ),
            ],
            if(index == 2) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addNewGroup(context);
                },
                child: Text('Создать новую группу'),
              ),
            ],
          ]
      ),
    );
  }
}