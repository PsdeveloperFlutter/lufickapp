import 'dart:math';

import 'package:flutter/material.dart';

class aniamteds extends StatefulWidget {
  const aniamteds({super.key});

  @override
  State<aniamteds> createState() => _aniamtedsState();
}

class _aniamtedsState extends State<aniamteds> {
   double wv=200;
   double wh=200;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedSwitcher(duration: Duration(seconds: 5),
            transitionBuilder: (Widget child,Animation<double>animation){
              return ScaleTransition(scale:animation,child: child,);
            },
            child: Container(
              width: wv,
                height: wh,
                color: Colors.blue.shade500,
            ),
            ),
          ),

          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
         setState(() {
           wv=wv.toDouble()*Random().nextDouble()+20;
           wh=wh.toDouble()*Random().nextDouble()+290;
         });

          }, child: Text("Incerement"))
        ],
      ) ,
    );
  }
}
void main(){
  runApp(MaterialApp(home:aniamteds(),));
}