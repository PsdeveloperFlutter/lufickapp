import 'package:flutter/material.dart';
import 'Notification1.dart'; // Ensure correct import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // ✅ Required for async calls in main()

  final NotificationService notificationService = NotificationService();
  await notificationService.initNotifications();  // ✅ Initialize notifications before runApp()

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Notifications Demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Notifications Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _notificationService.scheduleNotification(
                0,
                'Custom Reminder',
                'This is a custom reminder notification!',
                DateTime.now().add(Duration(seconds: 5)),  // ✅ Now correctly converted to timezone
              );
            },
            child: Text('Schedule Notification'),
          ),
        ),
      ),
    );
  }
}
