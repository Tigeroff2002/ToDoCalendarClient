import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/models/requests/UserLoginModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/ResponseWithToken.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход в существующую учетную запись'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Электронная почта: ',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль: ',
              ),
            ),
            SizedBox(height: 25.0),
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
                login(context);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    var model = new UserLoginModel(email: email, password: password);

    var requestMap = model.toJson();

    final url = Uri.parse('http://localhost:5201/users/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {

      var jsonData = jsonDecode(response.body);
      var responseContent = ResponseWithToken.fromJson(jsonData);

      MySharedPreferences mySharedPreferences = new MySharedPreferences();

      await mySharedPreferences.clearData();

      await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)
          => UserPage()),
      );
      emailController.clear();
      passwordController.clear();

    } else {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Неверная почта или пароль!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    passwordController.clear();
  }
}