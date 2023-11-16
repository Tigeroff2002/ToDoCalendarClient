import 'package:flutter/material.dart';
import 'dart:async';

import 'package:todo_calendar_client/user_page.dart';

class AdditionalPageWidget extends StatefulWidget {

  @override
  _AdditionalPageState createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPageWidget> {
  String pictureUrl = "https://source.unsplash.com/random/800x600";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Список мероприятий'),
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserPage()),);
            },
          ),
        ),
        body: Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: changeURLByClick,
              child: Image.network(pictureUrl),
            ),
          ),
        )
    );
  }

  void changeURLByClick() {
    setState(() {
      pictureUrl = "https://source.unsplash.com/random/800x600/?" +
          "q=${new DateTime.now().millisecondsSinceEpoch}";
    });
  }


  void changeURLByTimer() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        pictureUrl = "https://source.unsplash.com/random/800x600/?" +
            "q=${new DateTime.now().millisecondsSinceEpoch}";
      });
    });
  }
}
