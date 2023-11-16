import 'package:flutter/material.dart';
import 'package:todo_calendar_client/events_list_page.dart';
import 'package:todo_calendar_client/groups_list_page.dart';
import 'package:todo_calendar_client/reports_list_page.dart';
import 'package:todo_calendar_client/tasks_list_page.dart';

class UserInfoMapPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomeMap(),
    );
  }
}

class HomeMap extends StatefulWidget {

  @override
  State<HomeMap> createState() => _HomeState();
}

class _HomeState extends State<HomeMap> {
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  final List<Widget> _children = [
    EventsListPageWidget(),
    GroupsListPageWidget(),
    TasksListPageWidget(),
    ReportsListPageWidget()
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
        title: Text('Личный кабинет пользователя'),
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
            icon: Icon(Icons.add_alarm),
            label: 'Мои мероприятия',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Мои группы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'Мои задачи на реализацию',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment_rounded),
            label: 'Мои отчеты',
          ),
        ],
      ),
    );
  }
}