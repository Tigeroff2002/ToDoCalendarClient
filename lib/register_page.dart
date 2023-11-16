import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_calendar_client/models/requests/UserRegisterModel.dart';
import 'package:todo_calendar_client/models/responses/additional_responces/ResponseWithToken.dart';
import 'dart:convert';
import 'package:todo_calendar_client/user_page.dart';
import 'package:todo_calendar_client/shared_pref_cached_data.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isAlerted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация нового пользователя'),
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
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Имя пользователя: ',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль: ',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Номер телефона: ',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                register(context);
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
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

    final url = Uri.parse('http://localhost:5201/users/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);

    final response = await http.post(url, headers: headers, body: body);

    var jsonData = jsonDecode(response.body);
    var responseContent = ResponseWithToken.fromJson(jsonData);

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    await mySharedPreferences.clearData();

    await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));

    if (responseContent.result)
    {
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
    }

    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
  }
}