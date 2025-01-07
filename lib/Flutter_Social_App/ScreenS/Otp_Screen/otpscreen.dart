import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lufickapp/Flutter_Social_App/ScreenS/Main_Page.dart';
import 'package:lufickapp/Flutter_Social_App/ScreenS/User_Profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Authentication"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isOtpSent ? "Verify OTP" : "Enter Your Phone Number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Phone Number Input
              if (!_isOtpSent)
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "+91 8950363565",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              // OTP Input
              if (_isOtpSent)
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    hintText: "6-digit code",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 20),
              // Loading Indicator
              if (_isLoading)
                Center(child: CircularProgressIndicator()),
              if (!_isLoading)
                Column(
                  children: [
                    // Send OTP or Verify OTP Button
                    ElevatedButton(
                      onPressed: () {
                        if (_isOtpSent) {
                          _verifyOtp();
                          Timer(const Duration(seconds: 10), () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>UserProfileScreen()));
                          });
                        } else {
                          _sendVerificationCode();
                        }
                      },
                      child: Text(_isOtpSent ? "Verify OTP" : "Send OTP"),
                    ),
                    const SizedBox(height: 10),
                    // Clear Button
                    ElevatedButton(
                      onPressed: () {
                        _phoneController.clear();
                        _otpController.clear();
                        setState(() {
                          _isOtpSent = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Clear"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to send OTP
  void _sendVerificationCode() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || !phoneNumber.startsWith("+")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid phone number with country code.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _showSuccessMessage("Phone number automatically verified!");

      },
      verificationFailed: (FirebaseException e) {
        _showErrorMessage("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
        _showSuccessMessage("OTP sent to $phoneNumber.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
        _showErrorMessage("Auto-retrieval timed out.");
      },
    );

    setState(() => _isLoading = false);
  }

  // Method to verify OTP
  void _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter the OTP.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      _showSuccessMessage("Phone number verified successfully!");
    } catch (e) {
      _showErrorMessage("Failed to verify OTP :- Enter Valid Otp.");
    }

    setState(() => _isLoading = false);
  }

  // Utility to show success messages
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Utility to show error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
