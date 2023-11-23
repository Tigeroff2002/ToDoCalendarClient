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

    var reportTypes = ['None', 'EventsReport', 'TasksReport'];

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
              SizedBox(height: 16.0),
              Text(
                'Тип отчета',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  items: reportTypes.map((String type){
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type));
                  }).toList(),
                  onChanged: (String? newType){
                    selectedReportType = newType.toString();
                  }),
              SizedBox(height: 12.0),
              Text(
                'Время начала отчета',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4.0),
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
                'Время окончания отчета',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4.0),
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

  String selectedReportType = 'None';

  DateTime selectedBeginDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();
}