import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Current_Weather_Screen.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class GooglesignClass {
  Future<void> handleSignIn(BuildContext context) async {
    try {
      await googleSignIn.signIn().then((value) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 3),
            pageBuilder: (context, animation, secondaryAnimation) => WeatherApp(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      });
    } catch (error) {
      print(error);
    }
  }

  static Future<void> handleSignOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => GoogleAuthenticationUIPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    } catch (error) {
      print(error);
    }
  }
}

class GoogleAuthenticationUIPage extends StatefulWidget {
  const GoogleAuthenticationUIPage({super.key});

  @override
  State<GoogleAuthenticationUIPage> createState() => _GoogleAuthenticationUIPageState();
}

class _GoogleAuthenticationUIPageState extends State<GoogleAuthenticationUIPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              "assets/images/weather.png",
              width: 150,
              height: 150,
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await GooglesignClass().handleSignIn(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.deepOrangeAccent.shade200,
              ),
              icon: Icon(Icons.login, color: Colors.white),
              label: Text(
                "Sign in with Google",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GoogleAuthenticationUIPage(),
  ));
}
