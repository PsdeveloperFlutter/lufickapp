import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Main_Page.dart';

class otpscreen extends StatefulWidget {
  final String verificationId;

  otpscreen({required this.verificationId});

  @override
  State<otpscreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<otpscreen> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false; // Loading state for better user experience

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6, // OTP length
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.phone),
                labelStyle: TextStyle(color: Colors.deepPurple.shade700),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Creating a PhoneAuthCredential using the OTP and verificationId
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      // Signing in the user with the created credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the HomeScreen after successful login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Invalid OTP or verification failed.\n$e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
