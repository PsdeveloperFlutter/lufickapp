import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../Database/Main_Database_App.dart';
 // Import the database helper

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification Clicked: ${response.payload}");
      },
    );
  }

  static Future<void> scheduleNotification({
    required String payload,
    required String title,
    required String body,
    required int reminderValue,
    required String selectedUnit,
    required String repeatOption,
    required int customInterval,
  }) async {
    try {
      Duration duration;
      switch (selectedUnit) {
        case 'Seconds':
          duration = Duration(seconds: reminderValue);
          break;
        case 'Minutes':
          duration = Duration(minutes: reminderValue);
          break;
        case 'Hours':
          duration = Duration(hours: reminderValue);
          break;
        case 'Days':
          duration = Duration(days: reminderValue);
          break;
        default:
          duration = Duration(minutes: 10);
      }

      tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(duration);

      if (repeatOption == 'Daily') {
        scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: 1));
      } else if (repeatOption == 'Weekly') {
        scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: 7));
      } else if (repeatOption == 'Monthly') {
        scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: 30));
      } else if (repeatOption == 'Custom') {
        scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: customInterval));
      }

      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      // Store the notification details in the database
      Map<String, dynamic> eventData = {
        'name': title,
        'date_time': scheduledTime.toIso8601String(),
        'reminder_time': reminderValue.toString(),
        'repeat_option': repeatOption,
        'custom_interval': customInterval,
      };

      print('Notification scheduled successfully and stored in database');
    } on PlatformException catch (e) {
      print('Error scheduling notification: ${e.message}');
    } on Exception catch (e) {
      print('Error scheduling notification: ${e.toString()}');
    } catch (e) {
      print('Unknown error scheduling notification: ${e.toString()}');
    }
  }
}
