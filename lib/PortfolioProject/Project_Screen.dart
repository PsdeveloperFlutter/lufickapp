import 'package:flutter/material.dart';
import 'dart:math';
import 'package:particles_fly/particles_fly.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: 500), () {
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
        title: Text("My Projects", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,

      ),
      body: Stack(
        children: [
          // Background particle animation
          ParticlesFly(
            connectDots: true,
            numberOfParticles: 80,
            isRandomColor: true,
            isRandSize: true,
            maxParticleSize: 15.0,
            particleColor: Colors.cyanAccent,
            speedOfParticles: 8.0,
            randColorList: [
              Colors.blue.shade700,
              Colors.redAccent.shade700,
              Colors.deepOrange.shade700,
              Colors.yellowAccent.shade700,
              Colors.greenAccent.shade700,
              Colors.blueGrey.shade700,
            ],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) => _buildAnimatedProjectCard("Project ${index + 1}")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProjectCard(String title) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_rotationAnimation.value)
            ..setEntry(3, 2, 0.002)
            ..rotateX(_rotationAnimation.value),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}