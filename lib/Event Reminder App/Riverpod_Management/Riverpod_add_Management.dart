import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


//Set the Riverpod Provider
final videoControllerProvider = StateNotifierProvider<VideoControllerNotifier, VideoPlayerController?>((ref) {
  return VideoControllerNotifier();
});



class VideoControllerNotifier extends StateNotifier<VideoPlayerController?> {
  VideoControllerNotifier() : super(null);

  Future<void> setVideo(XFile videoFile) async {
    // Dispose old controller if it exists
    state?.dispose();

    // Create a new video controller
    final controllers = VideoPlayerController.file(File(videoFile.path));

    await controllers.initialize();
    state = controllers;  // Update state
    controllers.play();  // Auto-play the video
  }

  @override
  void dispose() {
    state?.dispose();  // Clean up resources
    super.dispose();
  }
}















// This is for managing the state of UI after selection of the image with Riverpod
final imageprovider = StateProvider<XFile?>((ref) => null);// This is for the Managing the state of the image
//This is for the Managing the state of the video

// Provider to manage selected file state
final fileProvider = StateProvider<PlatformFile?>((ref) => null);


// Define an enum for clarity
enum PriorityLevel { high, medium, low }
// Create a Riverpod StateProvider for managing the selected priority level
final radioButtonProvider = StateProvider<PriorityLevel?>((ref) => null);