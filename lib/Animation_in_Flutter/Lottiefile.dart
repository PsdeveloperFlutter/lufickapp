import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SimpleStatelessWidget extends StatefulWidget {
  @override
  State<SimpleStatelessWidget> createState() => _SimpleStatelessWidgetState();
}

class _SimpleStatelessWidgetState extends State<SimpleStatelessWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Stateless Widget'),
      ),
      body: Column(
        children: [
          Center(
            child:Lottie.network('https://lottie.host/embed/004b9814-b2e8-426e-a563-8fac6364f82d/iDewLckLKF.lottie'
            ,height: 200,width: 200),

          ),
        ],
      ),
    );
  }
}
void main(){
  runApp(MaterialApp(home:SimpleStatelessWidget()));
}