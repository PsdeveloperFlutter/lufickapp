import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<void> googleLogin(BuildContext context) async {
        try {
            // Ensure previous session is cleared before signing in
            await _googleSignIn.signOut();

            // Attempt to sign in
            final GoogleSignInAccount? user = await _googleSignIn.signIn();

            if (user != null) {
                final String? email = user.email;
                final String? name = user.displayName;
                print("User Details \n  Name: $name \n Email: $email");

                if (!context.mounted) return; // Prevent navigation error
                // Navigate to main page after successful login
                Navigator.pushReplacementNamed(context, '/mainpage');
            } else {
                print("User canceled the sign-in process.");
            }
        } catch (e) {
            print("Google Sign-In Error: $e");
        }
    }
}
