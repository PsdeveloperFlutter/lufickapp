import 'dart:math';

import 'package:flutter/material.dart';

class animationcontainer extends StatefulWidget {
  const animationcontainer({super.key});

  @override
  State<animationcontainer> createState() => _animationcontainerState();
}

class _animationcontainerState extends State<animationcontainer> {
  double width=100;
  double height=100;
  Color color=Colors.blue;
  BorderRadiusGeometry borderRadius=BorderRadius.circular(8);

  void changeProperties(){

     setState(() {
       final random=Random();
       width = random.nextDouble() * 200 + 100;
       height = random.nextDouble() * 200 + 100;
       color = Color.fromRGBO(
           random.nextInt(256),
           random.nextInt(256),
       random.nextInt(256),
       1);
       borderRadius = BorderRadius.circular(random.nextDouble() * 50);
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          AnimatedContainer(duration: Duration(milliseconds: 300),
          curve:  Curves.easeInOut,
          width: width,
            height: height,
            	decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius
              ),
          )
        ],
      )
    , floatingActionButton: FloatingActionButton(
      onPressed: changeProperties,
      child: const Icon(Icons.play_arrow),
    ),
    );

  }
}

void main(){
  runApp(MaterialApp(home:animationcontainer(),));
}