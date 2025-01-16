import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import'package:file_picker/file_picker.dart';

// Main application class
class Mainpage_event_management extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.music_note, color: Colors.white)),
                Tab(icon: Icon(Icons.music_video, color: Colors.white)),
                Tab(icon: Icon(Icons.camera_alt, color: Colors.white)),
                Tab(icon: Icon(Icons.grade, color: Colors.white)),
                Tab(icon: Icon(Icons.email, color: Colors.white)),
              ],
            ),
            title: const Text(
              'Event Reminder App',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
          body: TabBarView(
            children: [
              const Center(child: Icon(Icons.music_note, size: 50)),
              EventCreationUI(),
              const Center(child: Icon(Icons.camera_alt, size: 50)),
              const Center(child: Icon(Icons.grade, size: 50)),
              const Center(child: Icon(Icons.email, size: 50)),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for Event Creation UI
class EventCreationUI extends StatefulWidget {
  @override
  _EventCreationUIState createState() => _EventCreationUIState();
}

class _EventCreationUIState extends State<EventCreationUI> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateTimeController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  // Function to pick date and time
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

        _eventDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the form
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RichText(
                text: const TextSpan(
                  text: "Create an Event",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "\nTo be Reminded",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),

            // Event Name Field
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.event, color: Colors.black45),
                hintText: "Enter the name of the event",
                label: const Text("Event Name"),
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
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.black45),
                hintText: "Enter Date and Time of the event",
                label: const Text("Event Date and Time"),
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
                suffixIcon: const Icon(Icons.location_on, color: Colors.black45),
                hintText: "Enter the Location of the event",
                label: const Text("Event Location"),
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
                suffixIcon: const Icon(Icons.description, color: Colors.black45),
                hintText: "Enter the description of the event",
                label: const Text("Event Description"),
              ),
            ),

            const SizedBox(height: 16),

            // Media Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle photo selection logic

                        ImagePicker imagePicker = ImagePicker();
                        showDialog(context: context, builder:(context){
                          return AlertDialog(
                            title: const Text("Select Option"),
                            content: const Text("Select the option to upload the photo"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
                                  Navigator.pop(context);
                                  image != null
                                      ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Image Selected: ${image.path}")))
                                      : print("Image not selected");
                                },
                                child: const Text("Gallery"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
                                  Navigator.pop(context);
                                  image != null
                                      ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Image Selected: ${image.path}")))
                                      : print("Image not selected");
                                },
                                child: const Text("Camera"),
                              ),
                            ],
                          );
                        });
                      },
                      icon: const Icon(Icons.photo_album, color: Colors.deepOrange),
                    ),
                    const Text("Photo", style: TextStyle(color: Colors.deepPurple))
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async{
                        // Handle video selection logic
                        XFile? video ;
                        ImagePicker imagePicker = ImagePicker();
                        showDialog(context: context, builder:(context){
                          return AlertDialog(
                            title: const Text("Select Option"),
                            content: const Text("Select the option to upload the video"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  video = await imagePicker.pickVideo(source: ImageSource.gallery);
                                  Navigator.pop(context);
                                  video != null
                                      ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Video Selected: ${video!.path}")))
                                      : print("Video not selected");
                                },
                                child: const Text("Gallery"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  video = await imagePicker.pickVideo(source: ImageSource.camera);
                                  Navigator.pop(context);
                                  video != null
                                      ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Video Selected: ${video!.path}")))
                                      : print("Video not selected");
                                },
                                child: const Text("Camera"),
                              ),
                            ],
                          );
                        } );
                      },
                      icon: const Icon(Icons.video_call, color: Colors.deepOrange),
                    ),
                    const Text("Video", style: TextStyle(color: Colors.deepPurple))
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle file selection logic
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            title: const Text("Select Option"),
                            content: const Text(
                                "Select the option to upload the file"),
                            actions: [
                              TextButton(onPressed: ()async{
                                FilePickerResult? result = await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  String? filePath = result.files.single.path;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("File Selected: $filePath")),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("File selection canceled")),
                                  );
                                }
                              }, child: Text("Single File"))
                            ]
                            );
                        });
                      },
                      icon: const Icon(Icons.edit_document, color: Colors.deepOrange),
                    ),
                    const Text("File", style: TextStyle(color: Colors.deepPurple))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers
    _eventNameController.dispose();
    _eventDateTimeController.dispose();
    _eventLocationController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }
}

void main() => runApp(Mainpage_event_management());
