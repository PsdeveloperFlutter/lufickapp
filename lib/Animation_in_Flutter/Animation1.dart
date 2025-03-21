import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Animation1(),
  ));
}

class Animation1 extends StatefulWidget {
  const Animation1({Key? key}) : super(key: key);

  @override
  State<Animation1> createState() => _Animation1State();
}

class _Animation1State extends State<Animation1> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<IconData> icons = [
    Icons.call,
    Icons.notifications,
    Icons.sms,
    Icons.menu,
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
        child: Flow(
          delegate: FlowMenuDelegate(controller: controller),
          children: icons.map((icon) => buildFAB(icon)).toList(),
        ),
      ),
    );
  }

  Widget buildFAB(IconData icon) {
    final isMenu = icon == Icons.menu;
    return Padding(
      padding: const EdgeInsets.all(120.0),
      child: FloatingActionButton(
        onPressed: () {
          if (controller.status == AnimationStatus.completed) {
            controller.reverse();
          } else {
            controller.forward();
          }
        },
        elevation: 5,
        backgroundColor: isMenu ? Colors.blue : Colors.green,
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  FlowMenuDelegate({required this.controller}) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = 100 * controller.value;
    for (int i = 0; i < context.childCount; i++) {
      final double angle = i * pi / (context.childCount - 2);
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) => true;
}