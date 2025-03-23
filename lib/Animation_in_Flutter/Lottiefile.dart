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
            child:Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_CTaizi.json',
                errorBuilder: (context, error, stackTrace) => Text("Failed to load animation")
            ),

          ),
        ],
      ),
    );
  }
}
void main(){
  runApp(MaterialApp(home:SimpleStatelessWidget()));
}