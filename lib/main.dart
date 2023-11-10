import 'package:flutter/material.dart';
import 'package:todo_calendar_client/user_info_map.dart';
import 'package:todo_calendar_client/home_page.dart';
import 'package:todo_calendar_client/api_requests.dart';
import 'package:todo_calendar_client/login_page.dart';
import 'package:todo_calendar_client/register_page.dart';
import 'package:todo_calendar_client/user_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Создание мероприятий в календаре',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/user_page': (context) => UserPage(),
        '/events_page': (context) => UserInfoMapPage()
   //     '/groups_page': (context) => EventsCalendarPage(),
   //     '/tasks_page': (context) => EventsCalendarPage(),
   //     '/reports_page': (context) => EventsCalendarPage()
      },
    );
  }
}


