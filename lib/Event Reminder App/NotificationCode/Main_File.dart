import'package:flutter/material.dart';
import 'package:lufickapp/Event%20Reminder%20App/NotificationCode/Local_Notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  // ✅ Initialize the timezone package
   tz.initializeTimeZones();
  runApp(MyAppNotification());
}


class MyAppNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              LocalNotification.showNotification(
                  title: 'Simple Notification',
                  body: 'This is Simple Notification', payload: 'This is Payload');

            }, child:Text("Simple Notification")),
            ElevatedButton.icon(onPressed: (){

              LocalNotification.scheduleNotification(payload: "", title: "This is Periodic", body: "This is the Periodic Notification");


                       }, label: Text("Periodic  Notification"), icon: Icon(Icons.schedule),)
          ],
        ),
      ),
    );
  }
}