import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/events_calendar.dart';
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';

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
        title: Text('Поиск вакансий'),
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

  final TextEditingController announcementNameController = TextEditingController();
  final TextEditingController announcementDescriptionController = TextEditingController();
  final TextEditingController announcementConditions_and_requirementsController = TextEditingController();

  PlaceholderWidget({required this.color, required this.text,required this.index});

  Future<void> add(BuildContext context) async
  {
    String name = announcementNameController.text;
    String description = announcementDescriptionController.text;
    String conditions_and_requirements= announcementConditions_and_requirementsController.text;

    final url = Uri.parse('http://172.20.10.3:8092/api_announcements/addAnnouncements');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'description': description,
      'conditions_and_requirements': conditions_and_requirements,
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }

    announcementNameController.clear();
    announcementDescriptionController.clear();
    announcementConditions_and_requirementsController.clear();
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
                controller: announcementNameController,
                decoration: InputDecoration(
                  labelText: 'Наименование мероприятия:',
                ),
              ),
              TextFormField(
                controller: announcementDescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Описание меропрития:',
                ),
              ),
              TextFormField(
                controller: announcementConditions_and_requirementsController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Условия и требования:',
                ),
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  add(context);
                },
                child: Text('Создать мероприятие'),
              ),
            ],
          ]
      ),
    );
  }
}