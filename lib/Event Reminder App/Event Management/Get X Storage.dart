import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
final GetStorage storage=GetStorage();
Map<String,dynamic> setdatatoGetxStorage(Map<String,dynamic>event){
  Map<String, dynamic> data = {
    'name': event['name'],
    'date_time': event['date_time'],
    'category': event['category'],
    'location': event['location'],
    'description':
    event['description'],
    'priority': event['priority'],
    'video_path':
    event['video_path'],
    'image_path':
    event['image_path'],
    'file_path': event['file_path']
  };
  return data;
}
Future<void> saveEvent(Map<String, dynamic> event, BuildContext context) async {
  try {
    print("Code run here successfully");

    // Retrieve the current list from savedEvents
    List<dynamic>? savedEventsDynamic = storage.read('savedEvent');

    // Explicitly cast the retrieved data to List<Map<String, dynamic>>
    List<Map<String, dynamic>> savedEvent = (savedEventsDynamic ?? [])

        .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)

        .toList();

    // Add the new event to the list
    savedEvent.add(event);

    // Write the updated list back to storage
    storage.write('savedEvents', savedEvent);


    try {
      // ✅ Backup logic begins here

      // Define the folder path where you want to store the backup
      String folderpath = '/storage/emulated/0/Download/eventreminder';

      // Step 1: Create the folder if it doesn't exist
      final Directory backupDir = Directory(folderpath);
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Step 2: Convert event list to JSON and save as bytes (UTF-8 encoded)
      File backupFile = File('$folderpath/backup.json');
      await backupFile.writeAsBytes(utf8.encode(jsonEncode(savedEvent)));

      // Step 3: Show Snackbar with loader and file path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              const SizedBox(width: 16),
              Expanded(child: Text("Data Backup Processing!")),
            ],
          ),
          behavior: SnackBarBehavior.floating,

        ),
      );


      // Step 3: Show Snackbar with loader and file path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Expanded(child: Text(" Data Save Successfully 	Backup File	: ${backupFile.path}")),
          behavior: SnackBarBehavior.floating,

        ),
      );


    } catch (e) {
      print("Exception occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save backup: $e")),
      );
    }



  } catch (e) {
    // Log the exception and rethrow it
    print("Exception occurred: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save data: $e")),
    );
    throw Exception("Data is not saved successfully");
  } finally {
    print("Code run here successfully");
  }
}//Retrieve list from the Get X storage
List<Map<String,dynamic>>getSavedEvents(){
  return storage.read('savedEvents');
}


//In which We are first check the list and after that convert the List datatype and after that we add the data in getX storage
