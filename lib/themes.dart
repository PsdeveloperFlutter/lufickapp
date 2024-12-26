import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreens extends StatefulWidget {
  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  // Controllers for form fields
  final TextEditingController controllerPassword = TextEditingController();

  final TextEditingController controllerMobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mobile number input
            TextField(
              controller: controllerMobile,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter your mobile number",
                hintStyle: TextStyle(color: Colors.blue.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Password input
            TextField(
              controller: controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.blue.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Login button
            ElevatedButton(
              onPressed: () => sendData(context),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> sendData(BuildContext context) async {
    // Validate input fields
    if (controllerMobile.text.isEmpty || controllerPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Prepare request body
    Map<String, String> requestBody = {
      'mobile': controllerMobile.text.trim(),
      'password': controllerPassword.text.trim(),
    };

    try {
      // Make HTTP POST request
      final response = await http.post(
        Uri.parse("https://quantapixel.in/ecommerce/grocery_app/public/api/sign-in"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Login successful
        final responseData = jsonDecode(response.body);
        print("Login Successful: $responseData");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!")),
        );

        // Navigate to another screen if needed
        // Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherScreen()));
      } else {
        // Login failed, display error message
        final responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? 'Login failed. Please try again.';
        print("Login failed with status: ${response.statusCode}, message: $errorMessage");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

}
