import 'package:flutter/material.dart';

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
    _sizeAnimation = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Color animation (changes from light color to another light color)
    _colorAnimation = ColorTween(
      begin: Colors.lightBlueAccent,
      end: Colors.pinkAccent,
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
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: _translateAnimation.value,
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
