import 'package:flutter/material.dart';

class animationrotation extends StatefulWidget {
  const animationrotation({super.key});

  @override
  State<animationrotation> createState() => _animationrotationState();
}

class _animationrotationState extends State<animationrotation> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double>animations;
  void initState(){
    super.initState();

    controller=AnimationController(vsync: this,duration: Duration(milliseconds: 800));
    animations=Tween<double>(begin: 0, end: 2 * 3.1416).
    animate(CurvedAnimation(parent: controller, curve: Curves.bounceIn));

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

            Center(
              child: AnimatedBuilder(animation: animations, builder: (context,child){

                return Transform.rotate(angle: animations.value,
                child: Center(
                  child: Container(
                    width: 200,
                    color: Colors.black,
                    height: 200,
                  ),
                ),
                );
              }),
            )
        ],
      )
    );
  }
}
void main(){
  runApp(MaterialApp(home:animationrotation()));
}