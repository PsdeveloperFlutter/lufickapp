import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController oldNameController = TextEditingController();
  final TextEditingController oldAgeController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newAgeController = TextEditingController();

  Future<void> updateData() async {
    final url = Uri.parse('http://192.168.29.65:3000/update-data');

    final body = jsonEncode({
      'oldname': oldNameController.text.trim(),
      'oldage': oldAgeController.text.trim(),
      'newname': newNameController.text.trim(),
      'newage': newAgeController.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        _showMessage("✅ Data updated successfully!");
      } else {
        _showMessage("❌ Failed to update: ${response.body}");
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    }
  }

  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Status'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    oldNameController.dispose();
    oldAgeController.dispose();
    newNameController.dispose();
    newAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Enter Old Data', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: oldNameController,
                decoration: const InputDecoration(labelText: 'Old Name'),
              ),
              TextField(
                controller: oldAgeController,
                decoration: const InputDecoration(labelText: 'Old Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text('Enter New Data', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: newNameController,
                decoration: const InputDecoration(labelText: 'New Name'),
              ),
              TextField(
                controller: newAgeController,
                decoration: const InputDecoration(labelText: 'New Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateData,
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
