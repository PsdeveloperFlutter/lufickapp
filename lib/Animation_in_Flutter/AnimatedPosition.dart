import 'dart:math';

import 'package:flutter/material.dart';

class animatedPosition extends StatefulWidget {
  const animatedPosition({super.key});

  @override
  State<animatedPosition> createState() => _animatedPositionState();
}

class _animatedPositionState extends State<animatedPosition> {
  @override
  Widget build(BuildContext context) {
    double lvalue=200;
    double rvalue=200;
    return Scaffold(
      body:Stack(
        children: [
          AnimatedPositioned(child:
          Container(
            width: 200,
            height: 200,
            color: Colors.blue.shade500,
          ), duration: Duration(milliseconds: 300),
            curve: Curves.bounceIn,
             left: lvalue,
            right: rvalue,

          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                 lvalue==200?Random().nextDouble()*200:lvalue=200;
                 rvalue==200?Random().nextDouble()*200:rvalue=200;

                });
              },
              child: Text("Move Box"),
            ),
          ),
        ],
      ) ,
    );
  }
}
void main(){
  runApp(MaterialApp(home:animatedPosition(),));
}