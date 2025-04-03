import 'package:flutter/material.dart';
import 'dart:math';

import 'package:particles_fly/particles_fly.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: -pi / 2, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(seconds:2), () {
      _controller.forward();
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
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(_animation.value)
              ..rotateY(_animation.value / 2)
              ..rotateZ(_animation.value / 4),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ParticlesFly(
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
            Positioned(
              top: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/ghibli-transformed-1743487333821.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 140, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Your Name", Icons.person),
                      SizedBox(height: 15),
                      _buildTextField("Your Email", Icons.email, keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 15),
                      _buildTextField("Subject", Icons.subject),
                      SizedBox(height: 15),
                      _buildTextField("Message", Icons.message, maxLines: 5),
                      SizedBox(height: 20),
                      _buildSubmitButton()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Message Sent Successfully!")),
            );
          }
        },
        child: Text("Send Message", style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
