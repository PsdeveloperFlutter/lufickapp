import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggingService {
  // For Login in Firebase
  static Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email and Password")));
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        print("Login Successful");
        Timer(Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/mainpage'); //Go to that Screen
           });
      }
    } catch (e) {
      print("Error Occurred in Login: $e");

    } finally {
      print("Code Run Successfully of Login in Firebase");
    }
  }

  // For Signup in Firebase
  static Future<void> signup(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        print("Please Enter Email and Password");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email and Password")));
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print("Signup Successful");
      }
    } catch (e) {
      print("Error Occurred in Signup: $e");
    } finally {
      print("Code Run Successfully of Signup in Firebase");
    }
  }

  // For Logout in Firebase
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Logout Successful");
    } catch (e) {
      print("Error Occurred in Logout: $e");
    } finally {
      print("Code Run Successfully of Signout in Firebase");
    }
  }
}
