import 'package:flutter/material.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Date Picker Timeline Example',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of user data
  final List<Map<String, dynamic>> userData = [
    {
      'name': 'John Doe',
      'age': 25,
      'rollno': 101,
      'date': DateTime(2025, 01, 02),
    },
    {
      'name': 'Jane Smith',
      'age': 22,
      'rollno': 102,
      'date': DateTime(2020, 08, 15),
    },
    {
      'name': 'Alice Johnson',
      'age': 23,
      'rollno': 103,
      'date': DateTime(2020, 09, 10),
    },
    {
      'name': 'Bob Brown',
      'age': 24,
      'rollno': 104,
      'date': DateTime(2020, 07, 24),
    },
  ];

  // Selected date
  DateTime? selectedDate;

  // Filtered list of users based on selected date
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Date Picker Timeline Example'),
      ),
      body: Column(
        children: [
          // Date Picker Timeline
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 11, bottom: 11),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
            child: FlutterDatePickerTimeline(
              startDate: DateTime(2025, 01, 01),
              endDate: DateTime(2025, 12, 30),
              initialSelectedDate: DateTime(2025, 01, 01),
              onSelectedDateChange: (dateTime) {
                setState(() {
                  selectedDate = dateTime;
                  // Filter users based on the selected date
                  filteredUsers = userData
                      .where((user) =>
                  user['date'].year == dateTime?.year &&
                      user['date'].month == dateTime?.month &&
                      user['date'].day == dateTime?.day)
                      .toList();
                });
              },
            ),
          ),

          SizedBox(height: 20),

          // Display selected date
          if (selectedDate != null)
            Text(
              'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

          SizedBox(height: 20),

          // Display filtered users
          if (filteredUsers.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text(
                          'Age: ${user['age']}, Roll No: ${user['rollno']}'),
                    ),
                  );
                },
              ),
            )
          else if (selectedDate != null)
            Expanded(
              child: Center(
                child: Text(
                  'No users found for the selected date.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}