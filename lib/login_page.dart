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
            SizedBox(height: 16.0),
            ElevatedButton(
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

    var jsonData = jsonDecode(response.body);
    var responseContent = ResponseWithToken.fromJson(jsonData);

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));

    if (responseContent.result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)
          => UserPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Неверный логин или пароль!'),
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

    emailController.clear();
    passwordController.clear();
  }
}