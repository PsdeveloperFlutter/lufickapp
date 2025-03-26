import 'package:flutter/material.dart';

class AnimationWork extends StatefulWidget {
  const AnimationWork({super.key});

  @override
  State<AnimationWork> createState() => _AnimationWorkState();
}

class _AnimationWorkState extends State<AnimationWork> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animations;

  @override
  void initState() {  // ✅ Corrected method name
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animations = Tween(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: controller, curve: Curves.bounceIn),
    );
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
      appBar: AppBar(title: Text("Explicit Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: animations,
          builder: (context, child) {
            return Transform.scale(
              scale: animations.value,  // ✅ Apply scale transformation
              child: Container(
                color: Colors.blue,
                width: 100,
                height: 100,
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnimationWork(),
  ));
}
