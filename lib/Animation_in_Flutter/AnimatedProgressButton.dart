import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({super.key});

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool isLoading = false; // ✅ Initialize isLoading to false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(32),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 24),
              minimumSize: Size.fromHeight(72),
              shape: StadiumBorder(),
            ),
            onPressed: isLoading ? null : () async { // ✅ Disable button while loading
              setState(() {
                isLoading = true;
              });

              await Future.delayed(Duration(seconds: 5));

              setState(() {
                isLoading = false;
              });
            },
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ Center align content
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(width: 16),
                Text("Please Wait...")
              ],
            )
                : Text("Login"),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ProgressButton()));
}
