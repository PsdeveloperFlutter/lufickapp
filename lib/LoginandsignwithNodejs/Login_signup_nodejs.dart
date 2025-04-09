import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> signup() async {
    final url = Uri.parse('http://192.168.29.65:3000/signup'); // ✅ Use your correct IP

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // ✅ Set content-type to JSON
      body: jsonEncode({
        'username': _username.text,
        'password': _password.text,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    try {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Signup done')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid response from server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _username, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: signup, child: Text('Signup'))
,
Spacer(),
            ElevatedButton(onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>loginPage()));
            }, child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
void main(){
  runApp(MaterialApp(
    home: SignupPage(),
  ));
}