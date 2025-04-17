// Extension to convert string to enum
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../Database/Main_Database_App.dart';

PriorityLevel stringToPriorityLevel(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return PriorityLevel.high;
    case 'medium':
      return PriorityLevel.medium;
    case 'low':
      return PriorityLevel.low;
    default:
      return PriorityLevel.medium; // Default value
  }
}

// Enum for priority levels
enum PriorityLevel { high, medium, low }

class UpdateEventUI extends StatefulWidget {
  final int index;
  final String eventName;
  final String eventDateTime;
  final String eventLocation;
  final String eventDescription;
  final String eventPriority; // Change this to String, we'll convert to enum
  dynamic imagepath;
  dynamic filepath;
  dynamic id;
  dynamic videopath;

  UpdateEventUI(
      {required this.index,
      required this.eventName,
      required this.eventDateTime,
      required this.eventLocation,
      required this.eventDescription,
      required this.eventPriority, // String value for priority
      this.imagepath,
      this.filepath,
      this.id,
      this.videopath});

  @override
  _UpdateEventUIState createState() => _UpdateEventUIState();
}

class _UpdateEventUIState extends State<UpdateEventUI> {
  late TextEditingController _eventNameController;
  late TextEditingController _eventDateTimeController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventDescriptionController;
  late PriorityLevel _selectedPriority;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.eventName);
    _eventDateTimeController =
        TextEditingController(text: widget.eventDateTime);
    _eventLocationController =
        TextEditingController(text: widget.eventLocation);
    _eventDescriptionController =
        TextEditingController(text: widget.eventDescription);
    _selectedPriority =
        stringToPriorityLevel(widget.eventPriority); // Convert string to enum
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _eventDateTimeController.text =
            DateFormat('dd-MM-yyyy HH:mm').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Update Event", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Event Name Field
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.event),
                  labelText: "Event Name",
                ),
              ),
              const SizedBox(height: 16),

              // Event Date and Time Field
              TextField(
                controller: _eventDateTimeController,
                readOnly: true,
                onTap: () => _selectDateTime(context),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: "Event Date and Time",
                ),
              ),
              const SizedBox(height: 16),

              // Event Location Field
              TextField(
                controller: _eventLocationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.location_on),
                  labelText: "Event Location",
                ),
              ),
              const SizedBox(height: 16),

              // Event Description Field
              TextField(
                controller: _eventDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.description),
                  labelText: "Event Description",
                ),
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<PriorityLevel>(
                value: _selectedPriority,
                items: PriorityLevel.values.map((PriorityLevel priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child:
                        Text(priority.toString().split('.').last.capitalize()),
                  );
                }).toList(),
                onChanged: (PriorityLevel? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Priority",
                ),
              ),
              const SizedBox(height: 24),
              widget.imagepath != null
                  ? Center(
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                File(widget.imagepath),
                                height: 200,
                                width: 300,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            label: Text(
                              "Upload another Image",
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            onPressed: () async {
                              ImagePicker image = ImagePicker();
                              XFile? file = await image.pickImage(
                                  source: ImageSource.gallery);
                              if (file != null) {
                                setState(() {
                                  widget.imagepath = file.path;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Image uploaded successfully")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Image not uploaded")));
                              }
                            },
                            icon: Icon(
                              Icons.track_changes_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "No Image ",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          label: Text(
                            "Upload Image",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onPressed: () async {
                            ImagePicker image = await ImagePicker();
                            XFile? imagestore = await image.pickImage(
                                source: ImageSource.gallery);
                            if (imagestore != null) {
                              setState(() {
                                widget.imagepath = imagestore.path;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Image uploaded successfully")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Image not uploaded")));
                            }
                          },
                          icon: Icon(
                            Icons.track_changes_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 24,
              ),

              widget.filepath != null
                  ? Column(
                      children: [
                        Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  child: seefile(widget.filepath))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          label: Text(
                            "Upload another file",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                //int age = 10;
                                widget.filepath = result.files.single.path;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("File uploaded successfully")));
                            }
                          },
                          icon: Icon(
                            Icons.track_changes_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "No File ",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          label: Text(
                            "Upload File",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                widget.filepath = result.files.single.path;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("File uploaded successfully")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("File not uploaded")));
                            }
                          },
                          icon: Icon(
                            Icons.track_changes_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(
                height: 24,
              ),
              widget.videopath != null
                  ? Column(
                      children: [
                        Center(
                          child: Text(
                            "Video Selected",
                            style: GoogleFonts.aBeeZee(fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          label: Text(
                            "Upload another Video",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();
                            final XFile? result = await picker.pickVideo(
                                source: ImageSource.gallery);
                            if (result != null) {
                              setState(() {
                                widget.videopath = result.path;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Video uploaded successfully")));
                            }
                          },
                          icon: Icon(
                            Icons.track_changes_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "No File ",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          label: Text(
                            "Upload Video",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();
                            final XFile? result = await picker.pickVideo(
                                source: ImageSource.gallery);
                            if (result != null) {
                              setState(() {
                                widget.videopath = result.path;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Video uploaded successfully")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Video not uploaded")));
                            }
                          },
                          icon: Icon(
                            Icons.track_changes_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(
                height: 24,
              ),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Handle event update logic here
                      final DatabaseHelper database =
                          await DatabaseHelper.instance;

                      final Map<String, dynamic> data = {
                        'name': _eventNameController.text,
                        'date_time': _eventDateTimeController.text,
                        'location': _eventLocationController.text,
                        'description': _eventDescriptionController.text,
                        'priority':
                            _selectedPriority.toString().split('.').last,
                        'image_path': widget.imagepath,
                        'file_path': widget.filepath,
                        'video_path': widget.videopath
                      };

                      //This is for the Show Result of Updation of the Data
                      database.updateEvent(data, widget.id).then((value) => {
                            print("Event updated successfully!"),
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Event updated successfully!"))),
                            Timer(Duration(seconds: 2),
                                () => Navigator.pop(context)),
                          });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Save Changes",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateTimeController.dispose();
    _eventLocationController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  //This is for See the video
  Widget seeVideo(String filepath) {
    // Create a video player controller
    VideoPlayerController? _controller;
    bool isPlaying = false;

    // Initialize the controller and play/pause functionality
    Future<void> _initializeVideoPlayer() async {
      _controller = VideoPlayerController.file(File(filepath))
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
          isPlaying = true;
        });
    }

    // Play or pause the video based on the current state
    void _togglePlayPause() {
      if (isPlaying) {
        _controller?.pause();
      } else {
        _controller?.play();
      }
      isPlaying = !isPlaying;
      setState(() {});
    }

    // Check if file exists and show video player or error message
    if (!File(filepath).existsSync()) {
      return Center(
        child: Text(
          "File not found!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    // Initialize the video player asynchronously
    _initializeVideoPlayer();

    return Column(
      children: [
        Center(
          child: _controller?.value.isInitialized ?? false
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : CircularProgressIndicator(),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          label: Text(
            isPlaying ? "Pause Video" : "Play Video",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          onPressed: _togglePlayPause,
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  //This is for see the File
  Widget seefile(String filepath) {
    File file = File(filepath);

    if (!file.existsSync()) {
      return Center(
        child: Text(
          "File not found!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    // Check file type based on extension
    String fileExtension = filepath.split('.').last.toLowerCase();

    if (["jpg", "jpeg", "png", "gif"].contains(fileExtension)) {
      // Display Image
      return Center(
          child: Image.file(
        file,
        fit: BoxFit.cover,
        width: 300,
        height: 200,
      ));
    } else if (["mp4", "mov", "avi"].contains(fileExtension)) {
      // Display Video
      return VideoPlayerWidget(videoFile: file);
    } else if (["pdf"].contains(fileExtension)) {
      // Display PDF
      return PDFViewWidget(pdfFile: file);
    } else {
      // Unsupported file type
      return Center(
        child: Text(
          "Unsupported file format!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }
  }
}

// Extension to capitalize strings
extension StringCapitalizeExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({Key? key, required this.videoFile})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {}); // Update the UI after initialization
        _controller.play(); // Auto-play video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class PDFViewWidget extends StatelessWidget {
  final File pdfFile;

  const PDFViewWidget({Key? key, required this.pdfFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: pdfFile.path,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
    );
  }
}
