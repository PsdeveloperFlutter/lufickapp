import 'dart:math';
import 'package:flutter/material.dart';

class RotateImg extends StatefulWidget {
  const RotateImg({super.key});

  @override
  State<RotateImg> createState() => _RotateImgState();
}

class _RotateImgState extends State<RotateImg> with SingleTickerProviderStateMixin {
  int rotateValue = 90;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 1));
        controller.reset();
      }
    });
    setRotation(rotateValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animation.value,
                  child: Container(
                    color: Colors.blue,
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: const Text(
                      "Priyanshu Satija",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int value in [90, 110, 180, 360])
                  TextButton(
                    onPressed: () {
                      setState(() {
                        rotateValue = value;
                        setRotation(rotateValue);
                      });
                    },
                    child: Text("$value"),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.forward(from: 0);
              },
              child: const Text("Rotate"),
            ),
          ],
        ),
      ),
    );
  }

  void setRotation(int degrees) {
    final angle = degrees * pi / 180;
    animation = Tween<double>(begin: 0, end: angle).animate(controller);
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RotateImg(),
  ));
}