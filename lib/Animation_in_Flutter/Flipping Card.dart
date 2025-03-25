import 'package:flutter/material.dart';
import 'dart:math';

class Flip3D extends StatefulWidget {
  const Flip3D({super.key});

  @override
  State<Flip3D> createState() => _Flip3DState();
}

class _Flip3DState extends State<Flip3D> {
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isFlipped = !isFlipped;
            });
          },
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
            duration: Duration(milliseconds: 600),
            builder: (context, double value, child) {
              bool isBack = value >= 90;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective effect
                  ..rotateY(pi * value / 180), // Rotate based on value
                child: isBack
                    ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: Image.asset("assets/images/nature1.jpg",
                      width: 250, height: 350, fit: BoxFit.cover),
                )
                    : Image.asset("assets/images/nature2.jpg",
                    width: 250, height: 350, fit: BoxFit.cover),
              );
            },
          ),
        ),
      ),
    );
  }
}
void main(){
  runApp(MaterialApp(
  home:Flip3D()
  ));
}
