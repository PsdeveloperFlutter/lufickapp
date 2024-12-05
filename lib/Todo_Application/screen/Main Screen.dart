import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Mainscreen(),
  ));
}

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: const Text(
          "ToDo App ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Mainpart(),
    );
  }
}

//This is the Main Part of Our Flutter Applications
Widget Mainpart(){
  return SingleChildScrollView(
    child: Column(
      children: [],
    ),
  );
}