import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lufickapp/Todo_Application/Backend/Database%20of%20Application.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

import 'Login_Screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  try {
    await DatabaseHelper.database;
  } catch (e) {
    print('Database initialization error: $e');
    // Optionally, handle the error if necessary (e.g., show a dialog or fallback)
  }

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

  // Now run your app
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: CircularParticleScreen(),
      ),
    );
  }
}

class CircularParticleScreen extends StatefulWidget {
  const CircularParticleScreen({super.key});

  @override
  State<CircularParticleScreen> createState() => _CircularParticleScreenState();
}

class _CircularParticleScreenState extends State<CircularParticleScreen> {
  void initState() {
    super.initState();
     Timer(
        Duration(seconds: 8),(){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
     }
     );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: Colors.blue,
          child: Particles(
            awayRadius: 150,
            particles: createParticles(),
            height: screenHeight,
            width: screenWidth,
            onTapAnimation: true,
            awayAnimationDuration: const Duration(milliseconds: 100),
            awayAnimationCurve: Curves.linear,
            enableHover: true,
            hoverRadius: 90,
            connectDots: false,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(

                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                  ),
                  child: Image.asset('assets/images/ToDoLogo (2).jpg',fit: BoxFit.cover,),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Text("ToDo App",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
          ],
        ),
      ],
    );
  }

  List<Particle> createParticles() {
    var rng = Random();
    List<Particle> particles = [];
    for (int i = 0; i < 140; i++) {
      particles.add(Particle(
        color: Colors.white.withOpacity(0.6),
        size: rng.nextDouble() * 10,
        velocity: Offset(rng.nextDouble() * 200 * randomSign(),
            rng.nextDouble() * 200 * randomSign()),
      ));
    }
    return particles;
  }

  double randomSign() {
    var rng = Random();
    return rng.nextBool() ? 1 : -1;
  }
}