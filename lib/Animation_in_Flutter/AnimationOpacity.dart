import 'package:flutter/material.dart';

class animatinopacity extends StatefulWidget {
  const animatinopacity({super.key});

  @override
  State<animatinopacity> createState() => _animatinopacityState();
}

class _animatinopacityState extends State<animatinopacity> {
  double opacity=0;
  void changeOpacity()=>setState(() {
    opacity=opacity==0?1:0;
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedOpacity(opacity:opacity,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          curve: Curves.fastLinearToSlowEaseIn
          , duration: Duration(milliseconds: 300))
        ],
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      changeOpacity();
    }),
    );

  }
}

void main(){
  runApp(MaterialApp(home:animatinopacity(),));
}