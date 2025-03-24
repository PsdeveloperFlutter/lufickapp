import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
class textanimation extends StatefulWidget {
  const textanimation({super.key});

  @override
  State<textanimation> createState() => _textanimationState();
}

class _textanimationState extends State<textanimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: buildtext("Hey I am Priyanshu satija what is your Name ?"),
      ),
    );
  }

  Widget buildtext(String s) {
    return Marquee(
      text:s,style:TextStyle(fontSize: 48,color: Colors.white),
      blankSpace:20,
      velocity:100
    );
  }
}
void main(){
  runApp(MaterialApp(home:textanimation());
}