import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPin extends StatefulWidget {
  const SetPin({super.key});

  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _securityAnswerController =
      TextEditingController();

  String? _selectedQuestion;

  final List<Map<String, String>> _securityQuestions = [
    {'key': 'Place', 'question': 'What is your favorite place?'},
    {'key': 'Food', 'question': 'What is your favorite food?'},
    {'key': 'Book', 'question': 'What is your favorite book?'},
  ];

  Future<void> _savetoPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', _pinController.text.toString());
    await prefs.setString(
        'securityQuestion', _selectedQuestion.toString() ?? '');
    await prefs.setString(
        'securityAnswer', _securityAnswerController.text.toString() ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN and security details saved')),
    );
    print('PIN: ${_pinController.text}');
    print('Security Question: ${_selectedQuestion}');
    print('Security Answer: ${_securityAnswerController.text}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set App Lock PIN'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PIN input
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter your PIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Security section title
            const Text(
              "Security Questions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Info text
            const Text(
              "These questions will help you when you forget your password. "
              "All your security answers will be encrypted and stored only on the local device.",
            ),
            const SizedBox(height: 20),
            // Dropdown for selecting security question
            DropdownButtonFormField<String>(
              value: _selectedQuestion,
              decoration: const InputDecoration(
                labelText: 'Select Security Question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              items: _securityQuestions
                  .map((q) => DropdownMenuItem<String>(
                        value: q['key'],
                        child: Text(q['question']!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuestion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Security answer input
            TextField(
              controller: _securityAnswerController,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Validation and logic
                  if (_pinController.text.isEmpty ||
                      _selectedQuestion == null ||
                      _securityAnswerController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  } else {
                    _savetoPreferences();
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
