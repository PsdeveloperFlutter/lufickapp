import 'package:flutter_riverpod/flutter_riverpod.dart';
 // Import your database helper file
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../Database/Main_Database_App.dart';


//Set the Riverpod Provider
final videoControllerProvider = StateNotifierProvider<VideoControllerNotifier, VideoPlayerController?>((ref) {
  return VideoControllerNotifier();
});


//This is for the Managing the Video Controller in This App
class VideoControllerNotifier extends StateNotifier<VideoPlayerController?> {
  VideoControllerNotifier() : super(null);

  Future<void> setVideo(XFile videoFile) async {
    // Dispose old controller if it exists
    state?.dispose();

    // Create a new video controller
    final controllers = VideoPlayerController.file(File(videoFile.path));

    await controllers.initialize();
    state = controllers;  // Update state
    //controllers.play();  // Auto-play the video
  }

  @override
  void dispose() {
    state?.dispose();  // Clean up resources
    super.dispose();
  }
}













// State provider for password visibility toggle in Login Page
final Switchvalue = StateProvider<bool>((ref) {
  return false; // Default: password hidden
});
//State provider for password visibility toggle in Sign Up Page
final Switchpassword=StateProvider<bool>((ref){
  return false;
});//This is false means hide for Initial


// This is for managing the state of UI after selection of the image with Riverpod
final imageprovider = StateProvider<XFile?>((ref) => null);// This is for the Managing the state of the image
//This is for the Managing the state of the video

// Provider to manage selected file state
final fileProvider = StateProvider<PlatformFile?>((ref) => null);


// Define an enum for clarity
enum PriorityLevel { high, medium, low }
// Create a Riverpod StateProvider for managing the selected priority level
final radioButtonProvider = StateProvider<PriorityLevel?>((ref) => null);





//This is for managing the Custom Tags for the Event For User and make sure of that State will manage Properly in this with River Pod with StateNotifier Provider


/*
How It Works
✅ User enters a tag → It is stored in GetStorage permanently.
✅ Tags are retrieved automatically when the app starts.
✅ Users can delete tags, and the list updates in real time.
✅ Uses Riverpod to manage state while storing data in GetStorage.

Now, even if the app is closed and reopened, the tags will persist! 🚀 Let me know if you need further refinements! 😊
*/


// GetStorage instance
final box = GetStorage();




final eventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final db = await databaseHelper.database; // Assuming 'database' is your SQLite database instance
  try {
    return db!.query('events');
  } catch (e) {
    print("SQLite Fetch Error: $e");
    return []; // Return an empty list on failure
  }
});
