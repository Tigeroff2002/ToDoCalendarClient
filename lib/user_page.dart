import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_calendar_client/widgets/EventPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/GroupPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/TaskPlaceholderWidget.dart';
import 'package:todo_calendar_client/widgets/ReportPlaceholderWidget.dart';

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
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  String url_picture = "https://source.unsplash.com/random/800x600";

  void changeURLByClick() {
    setState(() {
      url_picture = "https://source.unsplash.com/random/800x600/?" +
          "q=${new DateTime.now().millisecondsSinceEpoch}";
    });
  }

  void changeURLOnTimer() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        url_picture = "https://source.unsplash.com/random/800x600/?" +
            "q=${new DateTime.now().millisecondsSinceEpoch}";
      });
    });
  }

  final List<Widget> _children = [
    EventPlaceholderWidget(
        color: Colors.red,
        text: 'Главная страница пользователя',
        index: 0
    ),

    EventPlaceholderWidget(
        color: Colors.green,
        text: 'Страница создания мероприятия',
        index: 1),

    GroupPlaceholderWidget(
        color: Colors.blueAccent,
        text: 'Страница создания новой группы',
        index: 2),

    TaskPlaceholderWidget(
        color: Colors.lime,
        text: 'Страница создания новой задачи',
        index: 3),

    ReportPlaceholderWidget(
        color: Colors.deepOrangeAccent,
        text: 'Страница создания нового отчета',
        index: 4)
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
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