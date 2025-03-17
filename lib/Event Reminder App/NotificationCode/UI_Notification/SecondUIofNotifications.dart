import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Initialize timezone database
  tzData.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotification(
    DateTime scheduledTime,
    String message,
    String name,
    String location,
    String description,
    String category,
    ) async {
  // Convert DateTime to TZDateTime
  final tz.TZDateTime scheduledTZDateTime = tz.TZDateTime.from(
    scheduledTime,
    tz.local,
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    '$name', // Notification Title
    '$description', // Notification Body
    scheduledTZDateTime, // Scheduled Time
    platformChannelSpecifics, // Notification Details
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: NotificationScreen(
        name: 'Event Name',
        location: 'Event Location',
        description: 'Event Description',
        category: 'Event Category',
        priority: 'Event Priority',
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  final String name;
  final String location;
  final String description;
  final String category;
  final String priority;

  NotificationScreen({
    required this.name,
    required this.location,
    required this.description,
    required this.category,
    required this.priority,
  });

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _scheduleNotification() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    if (widget.name.isEmpty ||
        widget.location.isEmpty ||
        widget.description.isEmpty ||
        widget.category.isEmpty ||
        widget.priority.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all event details')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final formattedDate =
    DateFormat('dd-MM-yyyy – kk:mm').format(scheduledDateTime);

    // Call the Schedule Notification Function
    scheduleNotification(
      scheduledDateTime,
      'Notification at $formattedDate',
      widget.name,
      widget.location,
      widget.description,
      widget.category,
    );

    // Show the result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for $formattedDate')),
    );
  }

  // Function to cancel the notification
  void _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0); // Cancel notification with ID 0
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification canceled')),
    );
  }
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Notification',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Date and Time",
              style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Date',
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
                hintText: 'Tap to choose a date',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                    selectedDate=pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Time',
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
                hintText: 'Tap to choose a time',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.access_time,
                  color: Colors.blue,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime=pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text(
                'Schedule Notification',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
