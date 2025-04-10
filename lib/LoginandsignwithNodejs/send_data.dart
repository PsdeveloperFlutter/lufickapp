import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lufickapp/LoginandsignwithNodejs/update_data.dart';

import 'Delete_data.dart';
import 'get_data.dart';

void main() {
  runApp(MyApp());
}

const String baseUrl = 'http://192.168.29.65:3000'; // For Android Emulator, use 127.0.0.1 for real device

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Node.js',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  bool isLoading = false;

  Future<void> sendData() async {
    final name = nameController.text.trim();
    final age = ageController.text.trim();

    if (name.isEmpty || age.isEmpty) return;

    final url = Uri.parse('$baseUrl/save-data');

    setState(() => isLoading = true);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'age': age}),
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.body)),
    );

    nameController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: ageController, decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : sendData,
              child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Send to Server'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewScreen()),
              ),
              child: Text('View Saved Data'),
            ),


            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateScreen()),
              ),
              child: Text('Update Data'),
            ),

            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeleteScreen()),
              ),
              child: Text('Delete Data'),
            ),
          ],
        ),
      ),
    );
  }
}
