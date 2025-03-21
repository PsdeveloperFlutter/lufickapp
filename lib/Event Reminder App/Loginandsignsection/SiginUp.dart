import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Firebase Functionality/Login and Signin Functionality .dart';



//Now We are working on the Password hide show Functionality with Riverpod and use the StateProvider in this code and make sure of that Do good State Management


//Code End here
final isValidEmailProvider = StateProvider<bool>((ref) => true);
class SignupPage extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Name Text Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),

              // Email Text Field


    TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(Icons.email),
        suffixIcon: ref.watch(isValidEmailProvider)
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

                Consumer(builder: (context, ref, child) {
                  return
                  // Password Text Field
                  TextField(
                    controller: passwordController,
                    obscureText: ref.watch(Switchpassword),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        ref.read(Switchpassword.notifier).update((state) => !state);

                      }, icon: Icon(ref.watch(Switchpassword)?Icons.visibility_off:Icons.visibility)),
                      prefixIcon:IconButton(onPressed: (){

                        }, icon: Icon(Icons.lock),),
                    ),
                  );
                }),
              SizedBox(height: 30),

              // Signup Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Function to Validate Email
                    bool isValidEmail(String email) {
                      String emailPattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      return RegExp(emailPattern).hasMatch(email);
                    }

                    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Email & Password cannot be empty!");
                      return;
                    }
                    //This Set the email Check here
                    if (!isValidEmail(emailController.text.toString())) {
                      Fluttertoast.showToast(msg: "Invalid Email ID");
                      return;
                    }
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      // Show a success message


                      //Save the data to Firebase for Signup Purpose in Firebase
                      LoggingService.signup(emailController.text, passwordController.text, context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account created successfully!'),
                        ),
                      );

                      // Navigate to Login Page after 2 seconds
                      Timer(Duration(seconds: 2), () {
                        Navigator.pushReplacementNamed(context, '/login');
                      });
                    } else {
                      // Show an error message if fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
