import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_calendar_client/home_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Имя',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: numberPhoneController,
              decoration: InputDecoration(
                labelText: 'Номер телефона',
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
    String numberPhone = numberPhoneController.text;

    final url = Uri.parse('http://172.20.10.3:8092/api_users/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'numberPhone': numberPhone,
      'email': email,
      'password': password
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else
    {
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
  }
}