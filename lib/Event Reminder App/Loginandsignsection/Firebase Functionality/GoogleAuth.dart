import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<void> googleLogin() async {
        await _googleSignIn.signIn();
        final GoogleSignInAccount? user = _googleSignIn.currentUser;
        if (user != null) {
            final String? email = user.email;
            final String? name = user.displayName;
            print("User Details \n  Name: $name \n Email: $email");
        } else {
            print("User is not signed in");
        }
    }
}