import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Database/Main_Database_App.dart';

// Function to pick a file

class AttachWithDB {
  final String name;
  final String date;
  final String description;
  final String location;
  final String category;
  final String priority;
  final PlatformFile? file; // Optional File
  final XFile? image;
  final XFile? video;
  final List<String>? customCategory; // Optional custom categories
  final String? reminderTime; // Stores the reminder time
  final String? repeatOption; // Repeat type (Daily, Weekly, etc.)
  final int? customInterval; // Stores custom interval (e.g., every 3 days)
 // Optional event ID for updating
  AttachWithDB({
    required this.name,
    required this.date,
    required this.description,
    required this.location,
    required this.category,
    required this.priority,
    this.file,
    this.image,
    this.video,
    this.customCategory,
    this.reminderTime,
    this.repeatOption,
    this.customInterval,
  });
  int eventId=0;
  void connect(BuildContext context) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    try {
      final eventData = {
        'name': name,
        'date_time': date,
        'description': description,
        'location': location,
        'category': category,
        'priority': priority,
        'file_path': file?.path ?? null, // ✅ Stores NULL if no file is provided
        'image_path': image?.path ?? null,
        'video_path': video?.path ?? null,
        'reminder_time': reminderTime ?? '',
        'repeat_option': repeatOption ?? '',
        'custom_interval': customInterval ?? null, // ✅ Correct NULL handling
      };
       eventId = await databaseHelper.insertEvent(eventData);
      if (eventId != -1) {
        print('✅ Event added with ID: $eventId');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event Created Sucessfully")));
        Timer(Duration(seconds: 2), () {
          // Get TabController and switch to first tab
          DefaultTabController.of(context)
              ?.animateTo(0); // If using DefaultTabController
        });
      } else {
        print('❌ Failed to insert event');
      }
    } catch (e) {
      print("❌ Database Insert Error: $e");
    }
  }
}
//This is for the Manging the File