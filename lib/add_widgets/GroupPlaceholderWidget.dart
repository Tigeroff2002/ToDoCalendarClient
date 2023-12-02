import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/models/requests/AddNewGroupModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';
import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class GroupPlaceholderWidget extends StatefulWidget{

  final Color color;
  final String text;
  final int index;

  GroupPlaceholderWidget({required this.color, required this.text, required this.index});

  @override
  GroupPlaceholderState createState(){
    return new GroupPlaceholderState(color: color, text: text, index: index);
  }
}

class GroupPlaceholderState extends State<GroupPlaceholderWidget> {
  final Color color;
  final String text;
  final int index;

  bool isNameValidated = true;

  final TextEditingController groupNameController = TextEditingController();

  GroupPlaceholderState(
      {
        required this.color,
        required this.text,
        required this.index
      });

  Future<void> addNewGroup(BuildContext context) async
  {
    String name = groupNameController.text;
    String groupType = selectedGroupType;

    var participants = [2, 3];

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();

      var model = new AddNewGroupModel(
          userId: (userId),
          token: token,
          groupName: name,
          groupType: groupType,
          participants: participants
      );

      var requestMap = model.toJson();

      final url = Uri.parse('http://127.0.0.1:5201/groups/create');
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

        groupNameController.clear();
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
  }

  @override
  Widget build(BuildContext context) {

    final groupTypes = ['None', 'Educational', 'Job'];

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
            if(index == 2) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  labelText: 'Наименование группы:',
                    errorText: !isNameValidated
                        ? 'Название группы не может быть пустым'
                        : null
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Тип группы:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  value: selectedGroupType,
                  items: groupTypes.map((String type){
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type));
                  }).toList(),
                  onChanged: (String? newType){
                    setState(() {
                      selectedGroupType = newType.toString();
                    });
                  }),
            ],
            if(index == 2) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isNameValidated = !groupNameController.text.isEmpty;

                    if (isNameValidated){
                      addNewGroup(context);
                    }
                  });
                },
                child: Text('Создать новую группу'),
              ),
            ],
          ]
      ),
    );
  }

  String selectedGroupType = "None";
}