import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'GoogleAuth.dart';
import 'SiginUp.dart';

//Now We are working on the Password hide show Functionality with Riverpod and use the StateProvider in this code and make sure of that Do good State Management


final Switchvalue=StateProvider<bool>((ref){
  return false;
});//This is false means hide for Initial



//Code End here

void main() async{

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAbY4ZNAKoZEi600VFVbKSwej-fLwWLaT0",
        appId: "1:927174904612:android:51df47f716d24d1b39c1b1",
        messagingSenderId: "927174904612",
        projectId: "lufickinternship-d0d28",
        storageBucket: "lufickinternship-d0d28.firebasestorage.app",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Optionally, handle the error if necessary
  }


  runApp(ProviderScope(
    child: MaterialApp(
    
      debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
        },
        home: LoginPage()),
  ));
}
class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Login to continue managing your events.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

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
                ),
              ),
              SizedBox(height: 20),

              // Password Text Field
               Consumer(builder: (context, ref, child) {
                 final values=ref.watch(Switchvalue);
                 return  TextField(
                   controller: passwordController,
                   obscureText: ref.watch(Switchvalue),
                   decoration: InputDecoration(
                     labelText: 'Password',
                     hintText: 'Enter your password',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                     prefixIcon:IconButton(onPressed: (){
                       ref.read(Switchvalue.notifier).update((state) => !state);
                     }, icon: Icon(values?Icons.lock:Icons.lock_open),)
                   ),
                 );
               }),
              SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Implement login logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: () {
                  // Implement Google Sign-In logic
                  GoogleAuth googleauth=GoogleAuth();
                  googleauth.googleLogin();

                  //Done the User Sign in with Google With Firebase Authentication


                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.g_mobiledata, size: 24, color: Colors.white),
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Navigate to Signup Page
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup'); // Define route
                },
                child: Text(
                  'Don’t have an account? Sign Up',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
