import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TtsDemo(),
    );
  }
}

class TtsDemo extends StatefulWidget {
  @override
  _TtsDemoState createState() => _TtsDemoState();
}

class _TtsDemoState extends State<TtsDemo> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.setLanguage("en-US"); // Set the language (e.g., en-US)
      await flutterTts.setPitch(1.0);        // Set the pitch (1.0 is normal)
      await flutterTts.setSpeechRate(0.5);   // Set the speech rate (0.5 is normal)
      await flutterTts.speak(text);         // Start speaking
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TTS Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Enter text to speak',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final text = textController.text;
                _speak(text);
              },
              child: Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop speaking when the widget is disposed
    textController.dispose();
    super.dispose();
  }
}
