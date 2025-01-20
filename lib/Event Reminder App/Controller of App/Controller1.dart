import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

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

  AttachWithDB({
    required this.name,
    required this.date,
    required this.description,
    required this.location,
    required this.category,
    required this.priority,
    this.file, // Required
    this.image,
    this.video,
    this.customCategory, // Optional
  });





}
