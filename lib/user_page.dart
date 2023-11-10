import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/events_calendar.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/models/requests/AddNewEventModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/Response.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PlaceholderWidget(color: Colors.red, text: 'Главная страница пользователя', index: 0),
    PlaceholderWidget(color: Colors.green, text: 'Страница создания мероприятия', index: 1),
    PlaceholderWidget(color: Colors.blueAccent, text: 'Страница создания новой группы', index: 2),
    PlaceholderWidget(color: Colors.lime, text: 'Страница создания новой задачи', index: 3),
    PlaceholderWidget(color: Colors.deepOrangeAccent, text: 'Страница создания нового отчета', index: 4)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Личный кабинет календаря пользователя'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.toc),
            label: 'Главная страница',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm),
            label: 'Создать новое мероприятие',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Создать новую группу',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'Создать новую задачу',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment_rounded),
            label: 'Создать новый отчет',
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;
  List<String> myList = [];

  final int userId = 1;
  final int groupId = 10;
  final String token = '0895439408';

  final TextEditingController eventCaptionController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController scheduledStartController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController eventStatusController = TextEditingController();

  PlaceholderWidget({required this.color, required this.text,required this.index});

  Future<void> add(BuildContext context) async
  {
    String caption = eventCaptionController.text;
    String description = eventDescriptionController.text;
    String scheduledStart = scheduledStartController.text;
    String duration = durationController.text;
    String eventType = eventTypeController.text;
    String eventStatus = eventStatusController.text;

    var guestIds = [2];

    var model = new AddNewEventModel(
        userId: (userId),
        token: token,
        caption: caption,
        description: description,
        start: scheduledStart,
        duration: duration,
        eventType: eventType,
        eventStatus: eventStatus,
        groupId: groupId,
        guestIds: guestIds);

    var requestMap = model.toJson();

    final url = Uri.parse('http://localhost:5201/events/schedule_new');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);
    final response = await http.post(url, headers: headers, body: body);

    var jsonData = jsonDecode(response.body);
    var responseContent = Response.fromJson(jsonData);

    if (responseContent.outInfo != null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseContent.outInfo.toString())
          )
      );
    }
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
                child: Text('Перейти к списку ваших мероприятий!'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
                },
                child: Text('Выйти'),
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: eventCaptionController,
                decoration: InputDecoration(
                  labelText: 'Наименование мероприятия:',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: eventDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание меропрития:',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: scheduledStartController,
                decoration: InputDecoration(
                  labelText: 'Время начала мероприятия',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: eventTypeController,
                decoration: InputDecoration(
                  labelText: 'Тип мероприятия',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: eventStatusController,
                decoration: InputDecoration(
                  labelText: 'Статус мероприятия',
                ),
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  add(context);
                },
                child: Text('Создать новое мероприятие'),
              ),
            ],
          ]
      ),
    );
  }
}