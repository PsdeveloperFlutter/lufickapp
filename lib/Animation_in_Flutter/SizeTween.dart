import 'package:flutter/material.dart';

class SizeTweens extends StatefulWidget {
  const SizeTweens({super.key});

  @override
  State<SizeTweens> createState() => _SizeTweensState();
}

class _SizeTweensState extends State<SizeTweens> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Size?> animationSize;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animationSize = SizeTween(
      begin: const Size(0, 0), // Start with zero size
      end: const Size(200, 200), // Final size
    ).animate(CurvedAnimation(parent: controller, curve: Curves.bounceIn));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SizeTween"),
      ),
      body: Column(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: animationSize,
              builder: (context, child) {
                final size = animationSize.value ?? const Size(0, 0); // Handle null safety
                return Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    "Tap Me",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ),
         SizedBox(height: 12,),
          ElevatedButton(onPressed: (){
            if (controller.status == AnimationStatus.completed) {
              controller.reverse(); // Reverse animation if already completed
            } else {
              controller.forward();
            }
          }, child: Text("Tap Me"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(home: SizeTweens()));
}
