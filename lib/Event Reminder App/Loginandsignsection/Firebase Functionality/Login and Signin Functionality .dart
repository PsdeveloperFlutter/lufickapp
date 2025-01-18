import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoggingService {
  // For Login in Firebase
  static Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email and Password")));
      } else {
        // Attempt to sign in
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        print("Login Successful");

        // Check if the user is authenticated before navigating
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Successfully logged in, navigate to the main page
          Get.offNamed('/mainpage'); // Use Get.offNamed to clear the login stack
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
        }
      }
    } catch (e) {
      print("Error Occurred in Login: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      print("Login process finished.");
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful")));
        Get.offNamed('/login'); // Redirect to login after successful signup
      }
    } catch (e) {
      print("Error Occurred in Signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    } finally {
      print("Signup process finished.");
    }
  }

  // For Logout in Firebase
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Logout Successful");
      Get.offNamed('/login'); // Redirect to login after logout
    } catch (e) {
      print("Error Occurred in Logout: $e");
    } finally {
      print("Logout process finished.");
    }
  }
}
