import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedPositionExample extends StatefulWidget {
  const AnimatedPositionExample({super.key});

  @override
  State<AnimatedPositionExample> createState() => _AnimatedPositionExampleState();
}

class _AnimatedPositionExampleState extends State<AnimatedPositionExample> {
  double lvalue = 50;
  double rvalue = 50;

  void _moveBox() {
    setState(() {
      // Randomly change left and right values
      lvalue = Random().nextDouble() * 200;
      rvalue = Random().nextDouble() * 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated Positioned Example")),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.bounceIn,
            left: lvalue,
            right: rvalue,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: ElevatedButton(
              onPressed: _moveBox,
              child: Text("Move Box"),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AnimatedPositionExample()));
}
