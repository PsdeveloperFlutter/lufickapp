import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedAlignExample(),
    );
  }
}

class AnimatedAlignExample extends StatefulWidget {
  @override
  _AnimatedAlignExampleState createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AnimatedAlign Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child: AnimatedAlign(
                duration: Duration(seconds: 1),
                alignment: _isMoved ? Alignment.bottomRight : Alignment.topLeft,
                curve: Curves.easeInOut,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isMoved = !_isMoved;
                });
              },
              child: Text("Move Box"),
            ),
          ],
        ),
      ),
    );
  }
}
