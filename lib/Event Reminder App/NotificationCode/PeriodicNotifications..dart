import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Periodic Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.initialize(); // Initialize notifications
  }

  // Trigger the periodic notification every 10 seconds
  void _startPeriodicNotifications() {
    _notificationHelper.schedulePeriodicNotification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Periodic notification started!')),
    );
  }

  // Cancel notifications
  void _cancelNotifications() {
    _notificationHelper.cancelNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications canceled!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Periodic Notification Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startPeriodicNotifications,
              child: const Text('Start Periodic Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cancelNotifications,
              child: const Text('Cancel Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    tzData.initializeTimeZones();
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule a periodic notification every 10 seconds
  Future<void> schedulePeriodicNotification() async {
    // Only need to call tz.initializeTimeZones() once in the initialize method

    // The initial notification time (1 second after the app starts)
    final firstNotificationTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));

    // Create the notification details
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'repeating_channel_id',
        'Repeating Notifications',
        channelDescription: 'Custom repeating notifications every 10 seconds',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Unique ID
      'Periodic Notification',
      'This notification repeats every 10 seconds!',
      firstNotificationTime, // Start after 1 second
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Match by time component
    );

    // Schedule the next notification 10 seconds after the current one
    Future.delayed(const Duration(seconds: 10), () {
      schedulePeriodicNotification(); // Call itself again for the next 10 seconds
    });
  }

  // Cancel all scheduled notifications
  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
