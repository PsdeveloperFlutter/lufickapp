import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _translateAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  final GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _translateAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _sizeAnimation = Tween<double>(
      begin: 200,
      end: 250,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.white,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Delay and then trigger the flip animation
    Future.delayed(Duration(milliseconds: 500), () {
      flipKey.currentState?.toggleCard();
    });
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
        title: Text("Contact Me"),
        centerTitle: true,
      ),
      body: Positioned(
        top: 100,
        left: 5,
        child: FlipCard(
          key: flipKey, // Set key for flip animation
          direction: FlipDirection.HORIZONTAL,
          front: _buildAnimatedContainer(),
          back: _buildAnimatedContainer(),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer() {
    return Center(
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
                  width: _sizeAnimation.value - 90,
                  height: _sizeAnimation.value,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 88),
                        _buildSectionTitle("Service"),
                        _buildInfoRow(FontAwesomeIcons.mobileAlt, "I Provide Service of Full Stack Mobile Development"),
                        _buildInfoRow(FontAwesomeIcons.code, "Create full Stack Mobile App with UI/UX Design and Backend Development"),
                        _buildSectionTitle("Skills"),
                        _buildInfoRow(FontAwesomeIcons.tools, "Flutter and Dart for frontend, Node.js and Sqflite for backend. Experience with Web Dev (HTML, CSS, JS), Oracle DB, and Kotlin Native with Jetpack Compose. Check my projects in the Project Section!"),
                        _buildInfoRow(FontAwesomeIcons.solidHeart, "State Management Experienced in BLoC, GetX, and Riverpod for efficient state management in Flutter applications."),
                        _buildInfoRow(FontAwesomeIcons.code, "HTML, CSS, JavaScript Strong understanding of HTML5, CSS3, and JavaScript ES6+ for frontend web development."),
                        _buildInfoRow(FontAwesomeIcons.server, "Node.js Skilled in Node.js backend development with Express.js for RESTful API creation."),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
