import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoPlayerInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoPath);
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {
            _isVideoPlayerInitialized = true;
          });
          _videoPlayerController.setLooping(true); // Optional: Loop the video
        });
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose(); // Dispose video controller properly
  }

  void _togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Video Player',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isVideoPlayerInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            ),
          ],
        )
            : CircularProgressIndicator(
          color: Colors.deepPurple,
        ), // Show a loading indicator while the video initializes
      ),
    );
  }
}
