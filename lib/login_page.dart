import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/models/requests/UserLoginModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/ResponseWithToken.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';
import 'package:todo_calendar_client/user_page.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState(){
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValidated = true;
  bool isPasswordValidated = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                errorText: !isEmailValidated
                    ? 'Почта не может быть пустой'
                    : null
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль: ',
                  errorText: !isPasswordValidated
                      ? 'Пароль не может быть пустым'
                      : null
              ),
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
              onPressed: () async {
                setState(() async {
                  isEmailValidated = !emailController.text.isEmpty;
                  isPasswordValidated = !passwordController.text.isEmpty;

                  if (isEmailValidated && isPasswordValidated){
                    await login(context);
                  }
                });
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

    final url = Uri.parse('http://127.0.0.1:5201/users/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);

    try {
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
    catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
      }
      else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      }
      else
        print("Unhandled exception: ${e.toString()}");
    }
  }
}