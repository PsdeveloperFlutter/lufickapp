import'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home:trans()));
}
class trans extends StatefulWidget {
  const trans({super.key});

  @override
  State<trans> createState() => _transState();
}

class _transState extends State<trans> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double>animations;
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    controller=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    animations=Tween<double>(begin: 0,end:200).animate(CurvedAnimation(parent: controller, curve: Curves.bounceIn));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [

          Container(
            child: AnimatedBuilder(animation: animations, builder: (context,child){
              return Transform.translate(
                offset: Offset(0, animations.value),
                child: Container(
                  width: 300,
                  height: 300,
                ),
              );
            }),
          )

        ],
      ) ,
    );
  }
}
