import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../Database/Main_Database_App.dart';
import '../Event Management/Event_manage_UI.dart';
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

  // FireBase Initialize
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAbY4ZNAKoZEi600VFVbKSwej-fLwWLaT0",
        appId: "1:927174904612:android:51df47f716d24d1b39c1b1",
        messagingSenderId: "927174904612",
        projectId: "lufickinternship-d0d28",
        storageBucket: "lufickinternship-d0d28.firebasestorage.app",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize GetX
  final ThemeController themeController = Get.put(ThemeController());

  // Initialize Database
  final db = await DatabaseHelper.instance.database;

  tz.initializeTimeZones(); // ✅ Initialize timezones before scheduling notifications
  await LocalNotification.init(); // ✅ Initialize local notifications

  runApp(ProviderScope(
    child: GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,

      // Setting up the Routes from here
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/mainpage': (context) => Mainpage_event_management(),
        '/event': (context) => CustomReminderScreen(),
      },
    ),
  ));
}

// 📌 This is the Login Page
class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Login to continue managing your events.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              Consumer(builder: (context, ref, child) {
                final isObscured = ref.watch(Switchvalue);
                return TextField(
                  controller: passwordController,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: IconButton(
                      onPressed: () {
                        ref.read(Switchvalue.notifier).update((state) => !state);
                      },
                      icon: Icon(isObscured ? Icons.lock : Icons.lock_open),
                    ),
                  ),
                );
              }),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  await LoggingService.login(email, password, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final GoogleAuth _googleAuth = GoogleAuth();
                  await _googleAuth.googleLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.g_mobiledata, size: 24, color: Colors.white),
                label: Text('Sign in with Google', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Don’t have an account? Sign Up', style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: 10),

              // 📌 Set Pin & Enter Pin Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SetPinScreen(),
                      );
                    },
                    child: Text("Set Pin", style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EnterPinScreen(),
                      );
                    },
                    child: Text("Enter Pin", style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📌 Set Pin Screen
class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final TextEditingController pinController = TextEditingController();

  void savePin() {
    String pin = pinController.text.trim();
    if (pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter a valid 4-digit PIN")));
      return;
    }
    setpinStorage.write("password_saved", pin);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PIN set successfully!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text("Set Your Pin"),
        content: TextField(controller: pinController, obscureText: true, decoration: InputDecoration(labelText: "Enter PIN")),
        actions: [TextButton(onPressed: savePin, child: Text("Save"))],
      ),
    );
  }
}

// 📌 Enter Pin Screen
class EnterPinScreen extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  void verifyPin(BuildContext context) {
    if (pinController.text.trim() == setpinStorage.read("password_saved")) {
      Navigator.pushReplacementNamed(context, '/mainpage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect PIN. Try again!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter Pin"),
      content: TextField(controller: pinController, obscureText: true, decoration: InputDecoration(labelText: "Enter PIN")),
      actions: [TextButton(onPressed: () => verifyPin(context), child: Text("Submit"))],
    );
  }
}
