import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../Event Management/Event_manage_UI.dart';
import '../Event Management/pinFunctionality.dart';
import '../Getx Storage/Them e Change getxController.dart';
import '../NotificationCode/Local_Notification.dart';
import '../NotificationCode/UI_Notification/UI_Notification.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Firebase Functionality/GoogleAuth.dart';
import 'Firebase Functionality/Login and Signin Functionality .dart';
import 'SiginUp.dart';

final GetStorage setpinStorage = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<dynamic> getPin = [];
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
    ));
    Future<List<dynamic>> gettoPreferences() async {
      List<dynamic> value = [];
      final prefs = await SharedPreferences.getInstance();
      value.add(prefs.getString('pin'));
      value.add(prefs.getString('securityQuestion'));
      value.add(prefs.getString('securityAnswer'));
      return value;
    }

    getPin = await gettoPreferences();
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
  User? user = FirebaseAuth.instance.currentUser;
  // ✅ Run the app
  runApp(ProviderScope(
    child: GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode:
          themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute:
      user != null && getPin.length != 2
          ? '/mainpage'
          : user != null && getPin.length == 2
              ? 'setpin'
              : '/login',
      // 👈 Check if user is logged in
      routes: {
        '/setpin': (context) => SetPin(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/mainpage': (context) => Mainpage_event_management(),
        '/event': (context) => CustomReminderScreen(),
      },
    ),
  ));
}

final isValidEmailProvider = StateProvider<bool>((ref) => true);
final switchValueProvider = StateProvider<bool>((ref) => true);

class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //This is for the purpose for the Set the loader to the Login Screen make sure of that

  bool loading = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValidEmail = ref.watch(isValidEmailProvider);
    final isObscured = ref.watch(switchValueProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
            child: loading == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Welcome to Event Reminder!',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Login to continue managing your events.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      // Email Input Field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: isValidEmail
                              ? null
                              : Tooltip(
                                  message: "Invalid Email ID",
                                  child: Icon(Icons.info, color: Colors.red),
                                ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(isValidEmailProvider.notifier)
                              .state = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value);
                        },
                      ),
                      SizedBox(height: 20),
                      // Password Input Field
                      TextField(
                        controller: passwordController,
                        obscureText: isObscured,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(isObscured
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              ref.read(switchValueProvider.notifier).state =
                                  !isObscured;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          ref.read(loadingProvider.notifier).setloading(true);
                          Future.delayed(Duration(seconds: 2), () async {
                            await LoggingService.login(
                                email, password, context);
                            ref
                                .read(loadingProvider.notifier)
                                .setloading(false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      // Divider for Google Sign-In
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1.2,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Or login with",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Google Sign-In Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          final GoogleAuth _googleAuth = GoogleAuth();
                          await _googleAuth.googleLogin(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white60,
                          // Google Sign-In button color
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Image.asset(
                          'assets/images/search.png', // Use your Google logo here
                          height: 24, // Adjust the size as needed
                        ),
                        label: const Text(
                          'Sign in with Google',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Sign Up Navigation
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('Don’t have an account? Sign Up',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  )),
      ),
    );
  }
}
