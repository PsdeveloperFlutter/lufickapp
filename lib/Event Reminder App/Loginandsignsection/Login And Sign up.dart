import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_app_check/firebase_app_check.dart';

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

  // ✅ Initialize SQLite Database
  final db = await DatabaseHelper.instance.database;

  // ✅ Initialize Timezones & Notifications
  tz.initializeTimeZones();
  await LocalNotification.init();

  User ? user = FirebaseAuth.instance.currentUser;

  // ✅ Run the app
  runApp(ProviderScope(
    child: GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? '/mainpage' : '/login',  // 👈 Check if user is logged in
      routes: {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValidEmail = ref.watch(isValidEmailProvider);
    final isObscured = ref.watch(switchValueProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Welcome to Event Reminder!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: isValidEmail
                      ? null
                      : Tooltip(
                    message: "Invalid Email ID",
                    child: Icon(Icons.info, color: Colors.red),
                  ),
                ),
                onChanged: (value) {
                  ref.read(isValidEmailProvider.notifier).state =
                      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value);
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      ref.read(switchValueProvider.notifier).state = !isObscured;
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
                  await LoggingService.login(email, password, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      style: TextStyle(color: Colors.black54, fontSize: 14),
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
                  backgroundColor: Colors.white60, // Google Sign-In button color
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                child: Text('Don’t have an account? Sign Up', style: TextStyle(color: Colors.blue)),
              ),

              SizedBox(height: 10),

              // Set Pin & Enter Pin Section
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


// 📌 This is the Login Page
// class LoginPage extends ConsumerWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: Text(
//                   'Welcome to Event Reminder!',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Login to continue managing your events.',
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 30),
//               TextField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//
//               Consumer(
//                 builder: (context, ref, child) {
//                   final isObscured = ref.watch(Switchvalue);
//                   return TextField(
//                     controller: passwordController,
//                     obscureText: isObscured,
//                     obscuringCharacter: '*',// We handle obscuring with custom formatter
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       hintText: 'Enter your password',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       prefixIcon: IconButton(
//                         icon: Icon( Icons.lock ),
//                         onPressed: () {
//                           ref.read(Switchvalue.notifier).state = !isObscured;
//                         },
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
//                         onPressed: () {
//                           ref.read(Switchvalue.notifier).state = !isObscured;
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//
//
//
//
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () async {
//                   final email = emailController.text.trim();
//                   final password = passwordController.text.trim();
//                   await LoggingService.login(email, password, context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   minimumSize: Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//               ),
//
//               const SizedBox(height: 20), // Space between buttons
//               Row(
//                 children: [
//                   const Expanded(
//                     child: Divider(
//                       color: Colors.grey,
//                       thickness: 1.2,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       "Or login with",
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),
//                   ),
//                   Expanded(
//                     child: Divider(
//                       color: Colors.grey,
//                       thickness: 1.2,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 20)
//               ,ElevatedButton.icon(
//                 onPressed: () async {
//                   final GoogleAuth _googleAuth = GoogleAuth();
//                   await _googleAuth.googleLogin(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white60, // Google Sign-In button color
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 icon: Image.asset(
//                   'assets/images/search.png', // Use your Google logo here
//                   height: 24, // Adjust the size as needed
//                 ),
//                 label: const Text(
//                   'Sign in with Google',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/signup');
//                 },
//                 child: Text('Don’t have an account? Sign Up', style: TextStyle(color: Colors.blue)),
//               ),
//               SizedBox(height: 10),
//
//               // 📌 Set Pin & Enter Pin Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (context) => SetPinScreen(),
//                       );
//                     },
//                     child: Text("Set Pin", style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold)),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => EnterPinScreen(),
//                       );
//                     },
//                     child: Text("Enter Pin", style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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


