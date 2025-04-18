import 'package:flutter/material.dart';
import 'package:lufickapp/Event%20Reminder%20App/Database/Main_Database_App.dart';

class FetchMultipleFile extends StatefulWidget {
  // final int eventId;
  // const FetchMultipleFile({super.key, required this.eventId});
  @override
  State<FetchMultipleFile> createState() => _FetchMultipleFileState();
}
class _FetchMultipleFileState extends State<FetchMultipleFile> {
  late Future<List<Map<String, dynamic>>> _filesFuture;
  @override
  void initState() {
    super.initState();
    _filesFuture = DatabaseHelper.instance.fetchEventFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No files found.'));
          } else {
            final files = snapshot.data!;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file['path'] ?? 'Unknown'),
                  subtitle: Text(file['extension'] ?? 'No extension'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
