import 'package:flutter/material.dart';
import 'package:todo_calendar_client/authorization_page.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';

class HomePage extends StatelessWidget {

  final String pictureUrlPart1 =
      'https://ssl.gstatic.com/calendar/images/dynamiclogo_2020q4/calendar_';

  final String pictureUrlPart2 = '_2x.png';

  @override
  Widget build(BuildContext context) {

    var monthDayNumber = DateTime.now().day.toString();
    var pictureUrl = pictureUrlPart1 + monthDayNumber + pictureUrlPart2;

    return MaterialApp(
        theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
      home: Scaffold(
        appBar: AppBar(
            title: Text('Календарь Tigeroff'),
            centerTitle: true
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  minimumSize: Size(200, 80),
                ),
                onPressed: () {
                  MySharedPreferences mySharedPreferences = new MySharedPreferences();

                  var cachedData =
                  mySharedPreferences.getDataIfNotExpired();

                  cachedData.then((value) =>
                  value == null
                      ?   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizationPage()),)
                      : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPage())));
                },
                child: Text('Запуск календаря'),
              ),
              SizedBox(height: 40),
              GestureDetector(
                  child: Image.network(pictureUrl)
              ),
            ],
          ),
        ),
      )
    );
  }
}