import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'Event Reminder App/Getx Storage/Them e Change getxController.dart';
import 'Event Reminder App/Loginandsignsection/Login And Sign up.dart';
import 'Event Reminder App/NotificationCode/Local_Notification.dart';
import 'Flutter_Social_App/ScreenS/Otp_Screen/otpscreen.dart';
import 'Weather_APP/Screens_of_APP/Google_authentication.dart';

class Mainclass extends StatelessWidget {
  const Mainclass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GoogleAuthenticationUIPage(),
                  ),
                );
              },
              child: Text('Weather App'),
            ),



            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Event Reminder App'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => PhoneAuthScreen(),
                  ),
                );
              },
              child: Text('Social Media App'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  // ✅ Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAbY4ZNAKoZEi600VFVbKSwej-fLwWLaT0",
        appId: "1:927174904612:android:51df47f716d24d1b39c1b1",
        messagingSenderId: "927174904612",
        projectId: "lufickinternship-d0d28",
        storageBucket: "lufickinternship-d0d28.appspot.com",
        authDomain: "lufickinternship-d0d28.firebaseapp.com",
      ),
    );

    // ✅ Initialize Firebase App Check (IMPORTANT)
    await FirebaseAppCheck.instance
    // Your personal reCaptcha public key goes here:
        .activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );


  } catch (e) {
    print('🔥 Firebase initialization error: $e');
  }

  // ✅ Initialize GetStorage
  await GetStorage.init();

  // ✅ Initialize GetX Theme Controller
  final ThemeController themeController = Get.put(ThemeController());


  // ✅ Initialize Timezones & Notifications
  tz.initializeTimeZones();
  await LocalNotification.init();

  User ? user = FirebaseAuth.instance.currentUser;


  runApp(ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Mainclass())));
}
