import 'package:flutter/material.dart';

class ZoomPhoto extends StatefulWidget {
  const ZoomPhoto({super.key});

  @override
  State<ZoomPhoto> createState() => _ZoomPhotoState();
}

class _ZoomPhotoState extends State<ZoomPhoto> with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      if (animation != null) {
        controller.value = animation!.value;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildImage(),
        ],
      ),
    );
  }

  Widget buildImage() {
    return GestureDetector(
      onDoubleTapDown: (details) => tapDownDetails = details,
      onDoubleTap: () {
        if (tapDownDetails == null) return; // Prevent null error

        final position = tapDownDetails!.localPosition;
        final double scale = 3.0;
        final double x = -position.dx * (scale - 1);
        final double y = -position.dy * (scale - 1);
        final zoomed = Matrix4.identity()..translate(x, y)..scale(scale);

        final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

        // Start Animation
        animation = Matrix4Tween(
          begin: controller.value,
          end: end,
        ).animate(CurveTween(curve: Curves.easeInOut).animate(animationController));

        animationController.forward(from: 0);
      },
      child: InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        panEnabled: false,
        scaleEnabled: false,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            "assets/images/fluttersocial.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ZoomPhoto()));
}
