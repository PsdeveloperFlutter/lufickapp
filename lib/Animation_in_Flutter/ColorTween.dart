import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home:colorTweens()));
}
class colorTweens extends StatefulWidget {

  @override
  State<colorTweens> createState() => _colorTweensState();
}

class _colorTweensState extends State<colorTweens> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Color?>animationscolor;

  void initState(){
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animationscolor = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
         AnimatedBuilder(animation: controller, builder: (context,child){
           return
             Container(
               width:200,
               height:200
               ,color:animationscolor.value
           );
         })
        ]
      )
    );
  }
}
