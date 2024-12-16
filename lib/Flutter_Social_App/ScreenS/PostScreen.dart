

// Screen 1: Post Screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_Page.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Center(
        child: InkWell(
          onTap: ()async{
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPages()));
          },
          child: Text(
            'This is the Post Screen',
            style: TextStyle(
              fontSize: screenHeight * 0.025, // Responsive font size
            ),
          ),
        ),
      ),
    );
  }
}
