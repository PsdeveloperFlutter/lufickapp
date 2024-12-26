import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lufickapp/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Theme Demos',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers for form fields
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerMobile = TextEditingController();
  final TextEditingController controllerPC = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreens()));
            },
            child: Text("hii")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFields for user input
              _buildTextField(controllerMobile, "Enter your mobile number"),
              SizedBox(height: 12),
              _buildTextField(controllerPassword, "Enter your password"),
              SizedBox(height: 12),
              _buildTextField(controllerPC, "Confirm password"),
              SizedBox(height: 12),
              _buildTextField(controllerName, "Enter your name"),
              SizedBox(height: 12),
              _buildTextField(controllerAddress, "Enter your address"),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => sendData(context),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.blue.shade500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> sendData(BuildContext context) async {
    // Prepare request body
    Map<String, String> requestBody = {
      'name': controllerName.text.trim(),
      'mobile': controllerMobile.text.trim(),
      'password': controllerPassword.text.trim(),
      'password_confirmation': controllerPC.text.trim(),
      'address': controllerAddress.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(
            "https://quantapixel.in/ecommerce/grocery_app/public/api/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        print("Registration Successful: $responseData");

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
      } else {
        // Handle errors
        print("Registration failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed. Try again.")),
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
