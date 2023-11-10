import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/models/responses/EventInfoResponse.dart';
import 'package:todo_calendar_client/models/requests/AddNewEventModel.dart';
import 'package:todo_calendar_client/user_page.dart';

class EventsCalendarPage extends StatefulWidget {
  @override
  EventsCalendarPageState createState() => EventsCalendarPageState();
}

class EventsCalendarPageState extends State<EventsCalendarPage> {

  final url = Uri.parse('http://localhost:5201/events/schedule_new');
  final headers = {'Content-Type': 'application/json'};
  bool isColor = false;

  List<EventInfoResponse> dataList = [];

  Future<void> addAnnouncement() async {
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_announcements/announcements_status_ok'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<EventInfoResponse>.from(jsonData.map((data) => EventInfoResponse.fromJson(jsonData)));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    addAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Список мероприятий'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPage()),);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            return Card(
              color: isColor ? Colors.red : Colors.teal,
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
                        utf8.decode(data.caption.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        utf8.decode(data.description.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Условия и требования:',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        utf8.decode(data.description.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Подтвердить приглашение'),
                        onPressed: () {},
                      ),
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