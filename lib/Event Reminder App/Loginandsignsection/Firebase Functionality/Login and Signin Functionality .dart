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
        showToast(context, "Please Enter Email and Password");
        return;
      }

      // Attempt to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("✅ Login Successful");

      // Check if the user is authenticated before navigating
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offNamed('/mainpage');
      } else {
        showToast(context, "❌ Login failed: User not authenticated");
      }
    } on FirebaseAuthException catch (e) {
      print("🔥 FirebaseAuthException Caught:");
      print("❌ Code: ${e.code}");
      print("❌ Message: ${e.message}");

      if (e.code == "wrong-password") {
        showToast(context, "Log in failed: Invalid password");
      } else if (e.code == "user-not-found") {
        showToast(context, "Log in failed: No user found with this email");
      } else if (e.code == "invalid-email") {
        showToast(context, "Log in failed: Invalid Email ID");
      } else {
        showToast(context, "Login failed: ${e.message}");
      }
    } catch (e) {
      print("⚠️ Generic Catch Block Error: $e");
      showToast(context, "Login failed: Something went wrong");
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
      showToast(context, "Signup failed: $e");
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
}
