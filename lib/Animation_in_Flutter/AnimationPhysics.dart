import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhysicsAnimationDemo(),
    );
  }
}

class PhysicsAnimationDemo extends StatefulWidget {
  const PhysicsAnimationDemo({super.key});

  @override
  _PhysicsAnimationDemoState createState() => _PhysicsAnimationDemoState();
}

class _PhysicsAnimationDemoState extends State<PhysicsAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _startSpringAnimation();
  }

  void _startSpringAnimation() {
    final spring = SpringDescription(
      mass: 1,
      stiffness: 100,
      damping: 10,
    );
    final simulation = SpringSimulation(spring, 0, 300, 0);
    _controller.animateWith(simulation);

    _animation = _controller.drive(Tween(begin: 0, end: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physics-Based Animations')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: _animation.value,
                  left: MediaQuery.of(context).size.width / 2 - 25,
                  child: child!,
                );
              },
              child: const BallWidget(),
            ),
          ),
          DraggableDemo()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BallWidget extends StatelessWidget {
  const BallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}

class DraggableDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Draggable(
          feedback: Container(
            width: 100,
            height: 100,
            color: Colors.red.withOpacity(0.5),
          ),
          childWhenDragging: Container(),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
