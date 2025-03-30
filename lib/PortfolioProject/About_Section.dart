import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
          },
          child: Text("Go to About Section"),
        ),
      ),
    );
  }
}

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Step 1: Rotation Animation (First Animation)
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: pi * 2)
        .animate(CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _colorController.forward(); // Start color animation after rotation completes
        }
      });

    // Step 2: Color Animation
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(begin: Colors.pink, end: Colors.blue.shade500)
        .animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _sizeController.forward(); // Start size animation after color animation completes
        }
      });

    // Step 3: Size Animation
    _sizeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _sizeAnimation = Tween<double>(begin: 100, end: 460).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );

    // Start the first animation when the screen appears
    Future.delayed(Duration(milliseconds: 300), () {
      _rotationController.forward();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        spacing: 12,
        closeManually: false,
        overlayColor: Colors.white,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.yellow,
              child: const Icon(Icons.info),
              label: "About Me",
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AboutScreen();

                }));
              }
          ),
          SpeedDialChild(
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.design_services),
            label: "Service",
          ),
          SpeedDialChild(
            backgroundColor: Colors.blueAccent.shade200,
            child: const Icon(Icons.developer_mode),
            label: "Project",
          ),
          SpeedDialChild(
            backgroundColor: Colors.redAccent.shade200,
            child: const Icon(Icons.phone, color: Colors.greenAccent),
            label: "Contact Me",
          ),
          SpeedDialChild(
            backgroundColor: Colors.purple.shade200,
            child: const Icon(Icons.file_present, color: Colors.white),
            label: "Resume",
          ),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _colorController, _sizeController]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value, // Rotation Animation
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: _sizeAnimation.value,
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                      child: _sizeAnimation.value > 100
                          ? SingleChildScrollView(
                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                            Text(
                              "Priyanshu Satija",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Flutter Developer | AI Enthusiast",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "I am a passionate Flutter developer with expertise in AI integrations, state management, and UI/UX design. I love creating modern and interactive mobile applications and also working with Smooth Animations and Currently Working as Flutter Developer in Min Product Base Company Lufick Technology Pvt Ltd ",
                              style: TextStyle(fontSize: 14, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                                                ],
                                              ),
                          )
                          : null,
                    ),


                    Positioned(
                      bottom: 410,
                      left: 50,
                      right: 50,
                      child:
                        CircleAvatar(
                         backgroundColor: Colors.purpleAccent,
                          radius: 50,
                          child: Center(
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/IMG-20250322-WA0060.jpg',
                               width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
