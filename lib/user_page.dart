import 'package:flutter/material.dart';
import 'package:todo_calendar_client/widgets/EventPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/GroupPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/TaskPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/ReportPlaceholderWidget.dart';

class UserPage extends StatelessWidget {

  final int userId;
  final String token;

  UserPage({this.userId = 1, this.token = '0895439408'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Home(userId: userId, token: token,),
    );
  }
}

class Home extends StatefulWidget {

  final int userId;
  final String token;

  Home({required this.userId, required this.token});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  static int userId = 0;
  static String token = '0895439408';

  void initState(){
    userId = widget.userId;
    token = widget.token;
  }

  final List<Widget> _children = [
    EventPlaceholderWidget(
        color: Colors.red,
        text: 'Главная страница пользователя',
        index: 0,
        userId: userId,
        token: token,
    ),

    EventPlaceholderWidget(
        color: Colors.green,
        text: 'Страница создания мероприятия',
        index: 1,
        userId: userId,
        token: token),

    GroupPlaceholderWidget(
        color: Colors.blueAccent,
        text: 'Страница создания новой группы',
        index: 2,
        userId: userId,
        token: token),

    TaskPlaceholderWidget(
        color: Colors.lime,
        text: 'Страница создания новой задачи',
        index: 3,
        userId: userId,
        token: token),

    ReportPlaceholderWidget(
        color: Colors.deepOrangeAccent,
        text: 'Страница создания нового отчета',
        index: 4,
        userId: userId,
        token: token)
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