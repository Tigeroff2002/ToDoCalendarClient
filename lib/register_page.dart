import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:todo_calendar_client/authorization_page.dart';
import 'package:todo_calendar_client/models/requests/UserRegisterModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/ResponseWithToken.dart';
import 'dart:convert';
import 'package:todo_calendar_client/user_page.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';

import 'GlobalEndpoints.dart';

class RegisterPage extends StatefulWidget{
  @override
  RegisterPageState createState(){
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isEmailValidated = true;
  bool isNameValidated = true;
  bool isPasswordValidated = true;
  bool isPhoneValidated = true;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
    String name = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    String phoneNumber = phoneNumberController.text;

    var model = new UserRegisterModel(
        email: email,
        name: name,
        password: password,
        phoneNumber: phoneNumber);

    var requestMap = model.toJson();

    var uris = GlobalEndpoints();

    bool isMobile = Theme.of(context).platform == TargetPlatform.android;

    var currentUri = isMobile ? uris.mobileUri : uris.webUri;

    var requestString = '/users/register';

    var currentPort = uris.currentPort;

    final url = Uri.parse(currentUri + currentPort + requestString);

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);

    try {
      final response = await http.post(url ,headers: headers, body : body);

      if (response.statusCode == 200)
      {
        var jsonData = jsonDecode(response.body);

        var responseContent = ResponseWithToken.fromJson(jsonData);

        MySharedPreferences mySharedPreferences = new MySharedPreferences();

        await mySharedPreferences.clearData();

        await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseContent.outInfo.toString()),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)
                => UserPage()));

        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        phoneNumberController.clear();
      }
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка!'),
            content: Text('Регистрация не удалась!'),
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

        passwordController.clear();
      }
    }
    catch (e) {
      if (e is SocketException) {
        //treat SocketException
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка!'),
            content: Text('Проблема с соединением к серверу!'),
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
      else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      }
      else
        print("Unhandled exception: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Регистрация нового аккаунта'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthorizationPage()),);
            },
          ),
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
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isEmailValidated
                        ? 'Почта не может быть пустой'
                        : null
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: 'Имя пользователя: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isNameValidated
                        ? 'Имя не может быть пустым'
                        : null
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Пароль: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isPasswordValidated
                        ? 'Пароль не может быть пустым'
                        : null
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                    labelText: 'Номер телефона: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isPhoneValidated
                        ? 'Номер телефона не может быть пустым'
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
                  setState(() {
                    isEmailValidated = !emailController.text.isEmpty;
                    isNameValidated = !usernameController.text.isEmpty;
                    isPasswordValidated = !passwordController.text.isEmpty;
                    isPhoneValidated = !phoneNumberController.text.isEmpty;

                    if (isEmailValidated && isPasswordValidated
                        && isNameValidated && isPhoneValidated){
                      register(context);
                    }
                  });
                },
                child: Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}