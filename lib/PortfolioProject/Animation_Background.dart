import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text('Services '),
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
                  lineStrokeWidth: 0.5,
                  lineColor: Colors.white,
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
                                   SizedBox(height: 88,),
                                   Center(
                                     child: Text(
                                       "Service",
                                       style: GoogleFonts.poppins(
                                         fontSize: 25,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.mobileAlt, color: Colors.black),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "I Provide Service of Full Stack Mobile Development",
                                           style: GoogleFonts.roboto(
                                             fontSize: 16,
                                             color: Colors.black,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.code, color: Colors.black),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "Create full Stack Mobile App with UI/UX Design and Backend Development",
                                           style: GoogleFonts.roboto(
                                             fontSize: 16,
                                             color: Colors.black,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 20),
                                   Center(
                                     child: Text(
                                       "Skills",
                                       style: GoogleFonts.poppins(
                                         fontSize: 25,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.tools, color: Colors.black),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "Flutter and Dart for frontend, Node.js and Sqflite for backend. Experience with Web Dev (HTML, CSS, JS), Oracle DB, and Kotlin Native with Jetpack Compose. Check my projects in the Project Section!",
                                           style: GoogleFonts.roboto(
                                             fontSize: 16,
                                             color: Colors.black,
                                           ),
                                         ),


                                       ),

                                     ],
                                   ),


                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.solidHeart, color: Colors.redAccent),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "State Management Experienced in BLoC, GetX, and Riverpod for efficient state management in Flutter applications.  Proficient in handling complex app architectures using MultiBlocProvider, Cubit, and reactive state updates.  Implemented BLoC pattern in multiple projects, including event-driven UI updates and optimized performance.",
                                           style: GoogleFonts.roboto(
                                             fontSize: 14,
                                             color: Colors.black,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.code, color: Colors.blueAccent),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "HTML, CSS, JavaScript Strong understanding of HTML5, CSS3, and JavaScript ES6+ for frontend web development.  Experience in responsive web design with Flexbox, Grid, and Media Queries.  Hands-on with JavaScript DOM manipulation, API integration, and event handling.",
                                           style: GoogleFonts.roboto(
                                             fontSize: 14,
                                             color: Colors.black,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Icon(FontAwesomeIcons.server, color: Colors.greenAccent),
                                       SizedBox(width: 10),
                                       Expanded(
                                         child: Text(
                                           "Node.js Skilled in Node.js backend development with Express.js for RESTful API creation.  Worked with MongoDB, Firebase, and SQLite for database management.  Experience in JWT authentication, middleware, and server-side rendering.",
                                           style: GoogleFonts.roboto(
                                             fontSize: 14,
                                             color: Colors.black,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),



                                 ],
                               ),
                             )

                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

              ),
              Positioned(
                top: 40,
                left: 108,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('assets/images/ghibli-transformed-1743487333821.png'
                    ,fit: BoxFit.cover,
                      width: 100,
                    ),
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
