import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class gs {
  static dynamic email,name;
   Signwithgoogle() async {

    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

    // Save the selected email in a variable
    String? selectedEmail = googleuser?.email;
    email=selectedEmail;
    GoogleSignInAuthentication? googleauth = await googleuser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleauth?.accessToken,
      idToken: googleauth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    name=userCredential.user?.displayName;
    print("Selected Email: $selectedEmail"); // Print the selected email
  }
}
