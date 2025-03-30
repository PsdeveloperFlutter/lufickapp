import 'package:flutter/material.dart';
import 'package:lufickapp/PortfolioProject/Background_Animation.dart';
import 'package:particles_fly/particles_fly.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnimatedContainerScreenservice(),
    );
  }
}

class AnimatedContainerScreenservice extends StatefulWidget {
  @override
  _AnimatedContainerScreenState createState() => _AnimatedContainerScreenState();
}

class _AnimatedContainerScreenState extends State<AnimatedContainerScreenservice> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _translateAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Translate animation (moves the container from the top to the center)
    _translateAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Start off-screen at the top
      end: Offset(0, 0), // End at the center
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Size animation (increases the container size)
    _sizeAnimation = Tween<double>(begin: 0.0, end: 400.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Color animation (changes from light color to another light color)
    _colorAnimation = ColorTween(
      begin: Colors.lightBlueAccent,
      end: Colors.white,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation after the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services App Bar'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(

            children: [
              Positioned(
                child: ParticlesFly(
                  connectDots: true,
                  numberOfParticles: 100,
                  isRandomColor: true,
                  isRandSize:true,
                  awayAnimationCurve: Curves.bounceInOut,
                  lineStrokeWidth: 3,
                  lineColor: Colors.green.shade200,
                  maxParticleSize: 20.0,
                  particleColor: Colors.cyanAccent.shade700,
                  speedOfParticles: 10.0,
                  randColorList: [
                    Colors.blue.shade700,
                    Colors.redAccent.shade700,
                    Colors.deepOrange.shade700,
                    Colors.yellowAccent.shade700,
                    Colors.greenAccent.shade700,
                    Colors.blueGrey.shade700,
                    Colors.brown.shade700,
                    Colors.purpleAccent.shade700,
                    Colors.pinkAccent.shade700,
                  ],
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top:100,
                left:5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _translateAnimation.value,
                            child: Container(
                              width: _sizeAnimation.value-90,
                              height: _sizeAnimation.value,
                              decoration: BoxDecoration(
                                color: _colorAnimation.value,
                                borderRadius: BorderRadius.circular(12),
                              ),
                             child: SingleChildScrollView(
                               child: Column(
                                 children: [
                                   Center(
                                     child: Text(
                                       "Service",
                                       style: TextStyle(
                                         fontSize: 25,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                     child: Text(
                                       "I Provide Service of Full Stack Mobile Development",
                                       style: TextStyle(
                                         fontSize: 18,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                     child: Text(
                                       "Create full Stack Mobile App with UI/UX Design and Backend Development ",
                                       style: TextStyle(
                                         fontSize: 18,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 20),
                                   Center(
                                     child: Text(
                                       "Skills",
                                       style: TextStyle(
                                         fontSize: 25,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                     child: Text(
                                       "Flutter and dart and for backend Node Js and Sqflite Database and I have also Experience working with Web Dev Technologies HTML CSS JAVASCRIPT and Oracle Database and Also have Experience working in Kotlin Native App Development with Jetpack compose with amazing ui you can check my project in Project Section",
                                       style: TextStyle(
                                         fontSize: 18,
                                           color: Colors.black,
                                       ),
                                     ),
                                   ),
                               
                               
                                 ],
                               ),
                             ),
                            ),
                          );
                        },
                      ),
                    ],
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
