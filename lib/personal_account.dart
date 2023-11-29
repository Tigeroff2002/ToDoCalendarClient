import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_info_map.dart';

import 'additional_page.dart';
import 'home_page.dart';

class PersonalAccount extends StatefulWidget{

  final Color color;
  final String text;
  final int index;

  PersonalAccount(
      {
        required this.color,
        required this.text,
        required this.index
      });

  @override
  PersonalAccountState createState(){
    return new PersonalAccountState(color: color, text: text, index: index);
  }
}

class PersonalAccountState extends State<PersonalAccount>{

  final Color color;
  final String text;
  final int index;

  PersonalAccountState(
      {
        required this.color,
        required this.text,
        required this.index
      });

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoMapPage()),);
                },
                child: Text('Перейти к вашему личному кабинету'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdditionalPageWidget()),);
                },
                child: Text('Дополнительная информация'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () {
                  MySharedPreferences mySharedPreferences = new MySharedPreferences();
                  mySharedPreferences.clearData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),);
                },
                child: Text('Выйти'),
              ),
            ],
          ),
        )
    );
  }
}