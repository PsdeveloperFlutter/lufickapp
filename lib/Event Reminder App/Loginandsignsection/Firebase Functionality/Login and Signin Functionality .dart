import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoggingService {
  // Helper function to show a Snackbar
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  //This is for the Login Purpose make sure of this
  static Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        showToast(context, "Please enter both email and password.");
        return;
      }



      // Try to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("✅ Login Successful");

      // Navigate to main page
      // Navigate to main page
Navigator.pushReplacementNamed(context, '/mainpage');


    } on FirebaseAuthException catch (e) {
      print("🔥 FirebaseAuthException Caught: ${e.code}");

      if (e.code == "invalid-credential") {
        showToast(context, "Incorrect password. Please try again.");
      } else if (e.code == "user-disabled") {
        showToast(context, "Your account has been disabled.");
      } else if (e.code == "invalid-email") {
        _showInvalidEmailMessage(context);

      } else {
        showToast(context, "Login failed: ${e.message}");
      }
    } catch (e) {
      print("⚠️ Error: $e");
      showToast(context, "Something went wrong. Please try again.");
    } finally {
      print("✅ Login process finished.");
    }
  }

  // For Signup in Firebase
  static Future<void> signup(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        print("Please Enter Email and Password");
        showToast(context, "Please Enter Email and Password");
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print("Signup Successful");
        showToast(context, "Signup successful");
        Get.offNamed('/login'); // Redirect to login after successful signup
      }
    } catch (e) {
      print("Error Occurred in Signup: $e");
    //  showToast(context, "Signup failed: $e");
      rethrow;
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
      rethrow;
    } finally {
      print("Logout process finished.");
    }
  }


  //This here we setup the show Invalid Email Message Option make sure of this

  static void _showInvalidEmailMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade100,
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.red), // ✅ Red info icon
            SizedBox(width: 8),
            Text("Invalid Email ID", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
