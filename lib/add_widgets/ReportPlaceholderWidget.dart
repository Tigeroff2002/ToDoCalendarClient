import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/models/requests/AddNewReportModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';
import '../GlobalEndpoints.dart';
import '../models/responses/additional_responces/ResponseWithToken.dart';
import '../shared_pref_cached_data.dart';

class ReportPlaceholderWidget extends StatefulWidget{

  final Color color;
  final String text;
  final int index;

  ReportPlaceholderWidget(
      {
        required this.color,
        required this.text,
        required this.index
      });

  @override
  ReportPlaceholderState createState(){
    return new ReportPlaceholderState(color: color, text: text, index: index, isPageJustLoaded: true);
  }
}

class ReportPlaceholderState extends State<ReportPlaceholderWidget> {

  final Color color;
  final String text;
  final int index;

  bool isPageJustLoaded;

  bool isBeginTimeChanged = false;
  bool isEndTimeChanged = false;

  bool isReportEndTimeGreaterThanBeginTime = true;
  bool isReportDurationValidated = true;

  final TextEditingController reportTypeController = TextEditingController();

  ReportPlaceholderState(
      {
        required this.color,
        required this.text,
        required this.index,
        required this.isPageJustLoaded
      });

  Future<void> addNewReport(BuildContext context) async
  {
    String reportType = selectedReportType;
    String beginMoment = selectedBeginDateTime.toString();
    String endMoment = selectedEndDateTime.toString();

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

      var uris = GlobalEndpoints();

      bool isMobile = Theme.of(context).platform == TargetPlatform.android;

      var currentUri = isMobile ? uris.mobileUri : uris.webUri;

      var requestString = '/reports/perform_new';

      var currentPort = uris.currentPort;

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

        reportTypeController.clear();
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
  }

  @override
  Widget build(BuildContext context) {

    var reportTypes = ['None', 'EventsReport', 'TasksReport'];

    var showingBeginHours = selectedBeginDateTime.hour.toString().padLeft(2, '0');
    var showingBeginMinutes = selectedBeginDateTime.minute.toString().padLeft(2, '0');

    var showingEndHours = selectedEndDateTime.hour.toString().padLeft(2, '0');
    var showingEndMinutes = selectedEndDateTime.minute.toString().padLeft(2, '0');

    if (isPageJustLoaded) {
      selectedBeginDateTime = DateTime.now();
      selectedEndDateTime = DateTime.now();
      isPageJustLoaded = false;

      if (!isBeginTimeChanged){
        showingBeginHours = (selectedBeginDateTime.hour + 1).toString().padLeft(2, '0');
        showingBeginMinutes = 0.toString().padLeft(2, '0');
      }

      if (!isEndTimeChanged){
        showingEndHours = (selectedEndDateTime.hour + 1).toString().padLeft(2, '0');
        showingEndMinutes = 0.toString().padLeft(2, '0');
      }
    }

    outputBeginDateTime = '${selectedBeginDateTime.year}'
        '/${selectedBeginDateTime.month}'
        '/${selectedBeginDateTime.day}'
        ' $showingBeginHours'
        ':$showingBeginMinutes';

    outputEndDateTime = '${selectedEndDateTime.year}'
        '/${selectedEndDateTime.month}'
        '/${selectedEndDateTime.day}'
        ' $showingEndHours'
        ':$showingEndMinutes';

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
              Text(
                'Тип отчета',
                style: TextStyle(fontSize: 20, color: Colors.deepPurple),
              ),
              SizedBox(height: 4.0),
              DropdownButton(
                  value: selectedReportType,
                  items: reportTypes.map((String type){
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type));
                  }).toList(),
                  onChanged: (String? newType){
                    setState(() {
                      selectedReportType = newType.toString();
                    });
                  }),
              SizedBox(height: 16.0),
              Text(
                'Время начала отчета',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
              SizedBox(height: 12.0),
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
                child: Text(outputBeginDateTime),
                onPressed: () async {
                  await pickBeginDateTime();
                  setState(() {
                    isBeginTimeChanged = true;
                    outputBeginDateTime =
                    '${selectedBeginDateTime.year}'
                        '/${selectedBeginDateTime.month}'
                        '/${selectedBeginDateTime.day}'
                        ' ${selectedBeginDateTime.hour}'
                        ':${selectedBeginDateTime.minute}';

                    isReportEndTimeGreaterThanBeginTime =
                        selectedEndDateTime.millisecondsSinceEpoch
                            > selectedBeginDateTime.millisecondsSinceEpoch;

                    isReportDurationValidated =
                        (selectedEndDateTime.difference(selectedBeginDateTime)
                            .inMilliseconds) < (3600 * 24 * 1000 * 30);
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Время окончания отчета',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
              SizedBox(height: 12.0),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isReportDurationValidated && isReportEndTimeGreaterThanBeginTime
                      ? Colors.green
                      : Colors.red,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.cyan,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minimumSize: Size(250, 100),
                ),
                child:
                isReportDurationValidated && isReportEndTimeGreaterThanBeginTime
                    ? Text(outputEndDateTime)
                    : !isReportEndTimeGreaterThanBeginTime
                    ? Text('Время окончания ' + outputEndDateTime
                    + ' должно быть больше времени начала')
                    : Text('Время окончания ' + outputEndDateTime
                    + ' должно быть не позже месяца после начала'),
                onPressed: () async {
                  await pickEndDateTime();
                  setState(() {
                    isEndTimeChanged = true;
                    outputBeginDateTime =
                    '${selectedEndDateTime.year}'
                        '/${selectedEndDateTime.month}'
                        '/${selectedEndDateTime.day}'
                        ' ${selectedEndDateTime.hour}'
                        ':${selectedEndDateTime.minute}';

                    isReportEndTimeGreaterThanBeginTime =
                        selectedEndDateTime.millisecondsSinceEpoch
                            > selectedBeginDateTime.millisecondsSinceEpoch;

                    isReportDurationValidated =
                        (selectedEndDateTime.difference(selectedBeginDateTime)
                            .inMilliseconds) < (3600 * 24 * 1000 * 30);
                  });
                },
              ),
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
                    isReportEndTimeGreaterThanBeginTime =
                        selectedEndDateTime.millisecondsSinceEpoch
                            > selectedBeginDateTime.millisecondsSinceEpoch;

                    isReportDurationValidated =
                        (selectedEndDateTime.difference(selectedBeginDateTime).inMilliseconds)
                            < (3600 * 24 * 1000 * 30);

                    if (isReportDurationValidated
                        && isReportEndTimeGreaterThanBeginTime){
                      realReportType = selectedReportType;
                      addNewReport(context);
                    }
                  });
                },
                child: Text('Создать новый отчет'),
              ),
          ]
      ),
      )
    );
  }

  String selectedReportType = 'None';

  DateTime selectedBeginDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();

  String realReportType = 'None';

  String outputBeginDateTime = '';
  String outputEndDateTime = '';
}