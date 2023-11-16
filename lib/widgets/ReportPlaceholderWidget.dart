import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/user_info_map.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewReportModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class ReportPlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;

  final TextEditingController reportTypeController = TextEditingController();
  final TextEditingController beginMomentController = TextEditingController();
  final TextEditingController endMomentController = TextEditingController();

  ReportPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index
      });

  Future<void> addNewGroup(BuildContext context) async
  {
    String reportType = reportTypeController.text;
    String beginMoment = beginMomentController.text;
    String endMoment = endMomentController.text;

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null) {
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var userId = cacheContent.userId;
      var token = cacheContent.token.toString();


      var model = new AddNewReportModel(
          userId: (userId),
          token: token,
          reportType: reportType,
          beginMoment: beginMoment,
          endMoment: endMoment
      );

      var requestMap = model.toJson();

      final url = Uri.parse('http://localhost:5201/reports/perform_new');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(requestMap);
      final response = await http.post(url, headers: headers, body: body);

      var jsonData = jsonDecode(response.body);
      var responseContent = Response.fromJson(jsonData);

      if (responseContent.result) {
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
          content: Text('Создание нового отчета не произошло!'),
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

    reportTypeController.clear();
    beginMomentController.clear();
    endMomentController.clear();
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
            if(index == 4) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: reportTypeController,
                decoration: InputDecoration(
                  labelText: 'Тип отчета: ',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: beginMomentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Время начала отчета: ',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: endMomentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Время окончания отчета: ',
                ),
              ),
            ],
            if(index == 4) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addNewGroup(context);
                },
                child: Text('Создать новый отчет'),
              ),
            ],
          ]
      ),
    );
  }
}