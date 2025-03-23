import 'package:flutter/material.dart';

enum ButtonState { init, loading, done }

class ProgressButtons extends StatefulWidget {
  const ProgressButtons({super.key});

  @override
  State<ProgressButtons> createState() => _ProgressButtonsState();
}

class _ProgressButtonsState extends State<ProgressButtons> {
  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isDone = state == ButtonState.done;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: state == ButtonState.init ? width : 70,
          height: 70,
          child: state == ButtonState.init ? buildButton() : smallButton(isDone),
        ),
      ),
    );
  }

  Widget buildButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: const BorderSide(width: 2, color: Colors.indigo),
      ),
      onPressed: () async {
        setState(() {
          state = ButtonState.loading;
        });
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          state = ButtonState.done;
        });
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          state = ButtonState.init;
        });
      },
      child: const Text(
        "Submit",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }
}

Widget smallButton(bool isDone) {
  final color = isDone ? Colors.green : Colors.indigo;
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    child: Center(
      child: isDone
          ? const Icon(Icons.done, color: Colors.white)
          : const CircularProgressIndicator(color: Colors.white),
    ),
  );
}

void main() {
  runApp(MaterialApp(home: ProgressButtons()));
}
