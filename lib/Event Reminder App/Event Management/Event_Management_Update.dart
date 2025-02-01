// Extension to convert string to enum
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  UpdateEventUI({
    required this.index,
    required this.eventName,
    required this.eventDateTime,
    required this.eventLocation,
    required this.eventDescription,
    required this.eventPriority, // String value for priority
    this.imagepath,
    this.filepath,
    this.id,
    this.videopath
  });

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
    _eventDateTimeController = TextEditingController(text: widget.eventDateTime);
    _eventLocationController = TextEditingController(text: widget.eventLocation);
    _eventDescriptionController = TextEditingController(text: widget.eventDescription);
    _selectedPriority = stringToPriorityLevel(widget.eventPriority); // Convert string to enum
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

        _eventDateTimeController.text = DateFormat('dd-MM-yyyy HH:mm').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Event", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update Event Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
          
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
                    child: Text(priority.toString().split('.').last.capitalize()),
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
              widget.imagepath!=null?
          
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(File(widget.imagepath),height: 200,width: 300,)),
                    SizedBox(height: 10,),
                    ElevatedButton.icon(
                      label: Text("Upload another Image",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                      onPressed: ()async{
                        ImagePicker image=ImagePicker();
                        XFile ?file=await image.pickImage(source:ImageSource.gallery);
                        if(file!=null){
                          setState(() {
                            widget.imagepath=file.path;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image uploaded successfully")));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not uploaded")));
                        }
                      },
                      icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                    ),
                  ],
                ),
              ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                     child:
                     Text("No Image ",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 15),)),
                      SizedBox(height: 10,),
                      ElevatedButton.icon(
                        label: Text("Upload Image",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                        onPressed: ()async{
                          ImagePicker image= await ImagePicker();
                           XFile ? imagestore=await image.pickImage(source: ImageSource.gallery);
                           if(imagestore!=null){
                             setState(() {
                               widget.imagepath=imagestore.path;
                             });
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image uploaded successfully")));
                           }
                           else {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not uploaded")));
                           }
                          },
                        icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                      ),
                    ],
                  ),
              const SizedBox(height: 24,),


            widget.filepath!=null ?
             Column(
               children: [
                 Center(
                   child: ClipRRect(
                       borderRadius: BorderRadius.circular(50),
                       child: Container(
                           width: 200,
                           height: 200,
                           child: seefile(widget.filepath))),
                 ),
                     SizedBox(height: 10,)
               ,ElevatedButton.icon(
                   label: Text("Upload another file",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                   onPressed: ()async{
                     FilePickerResult? result=await FilePicker.platform.pickFiles();
                     if(result!=null){
                       setState(() {
                         widget.filepath=result.files.single.path;
                       });
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully")));
                     }
                   },
                   icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                 ),
               ],
             ):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("No File ",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 15),)),
                SizedBox(height: 10,),
                ElevatedButton.icon(
                  label: Text("Upload File",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                  onPressed: ()async{
                    FilePickerResult? result=await FilePicker.platform.pickFiles();
                    if(result!=null){
                     setState(() {
                       widget.filepath=result.files.single.path;
                     });
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully")));
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File not uploaded")));
                    }
                  },
                  icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                ),
              ],
            ),

        const SizedBox(height: 24,),
              widget.videopath!=null ?
              Column(
                children: [
                  Center(
                    child: Text("Video Selected",style: GoogleFonts.aBeeZee(fontSize: 15),),
                  ),
                  SizedBox(height: 10,)
                  ,ElevatedButton.icon(
                    label: Text("Upload another Video",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                    onPressed: ()async{
                      ImagePicker picker=ImagePicker();
                      final XFile? result = await picker.pickVideo(source: ImageSource.gallery);
                      if(result!=null){
                        setState(() {
                          widget.videopath = result.path;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video uploaded successfully")));
                      }
                    },
                    icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                  ),
                ],
              ):
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("No File ",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 15),)),
                  SizedBox(height: 10,),
                  ElevatedButton.icon(
                    label: Text("Upload Video",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 12),),
                    onPressed: ()async{
                      ImagePicker picker=ImagePicker();
                      final XFile? result = await picker.pickVideo(source: ImageSource.gallery);
                      if(result!=null){
                        setState(() {
                          widget.videopath = result.path;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video uploaded successfully")));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video not uploaded")));
                      }
                    },
                    icon: Icon(Icons.track_changes_outlined,color: Colors.red,),
                  ),
                ],
              ),





        const SizedBox(height: 24,),


              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      // Handle event update logic here
                      final DatabaseHelper database=await DatabaseHelper.instance;

                      final Map<String, dynamic> data={
                        'name': _eventNameController.text,
                        'date_time': _eventDateTimeController.text,
                        'location': _eventLocationController.text,
                        'description': _eventDescriptionController.text,
                        'priority': _selectedPriority.toString().split('.').last,
                        'image_path': widget.imagepath,
                        'file_path': widget.filepath,
                        'video_path': widget.videopath
                      };


                      //This is for the Show Result of Updation of the Data
                      database.updateEvent(data, widget.id).then((value)=>{
                        print("Event updated successfully!"),
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event updated successfully!"))),
                        Timer(Duration (seconds: 2), () => Navigator.pop(context)),
                      });


                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Cancel", style: TextStyle(color: Colors.white)),
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
      return Center(child: Image.file(file, fit: BoxFit.cover,width: 300,height: 200,));
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



/*





Sure! Here's the same explanation converted into comments within the code. This will help you understand the theory behind each change directly in the code:

```dart
// This function converts a string (like 'high', 'medium', 'low') into the corresponding PriorityLevel enum
PriorityLevel stringToPriorityLevel(String priority) {
  switch (priority.toLowerCase()) {
    case 'high': // If the string is 'high', return the PriorityLevel.high enum value
      return PriorityLevel.high;
    case 'medium': // If the string is 'medium', return the PriorityLevel.medium enum value
      return PriorityLevel.medium;
    case 'low': // If the string is 'low', return the PriorityLevel.low enum value
      return PriorityLevel.low;
    default: // If the string doesn't match any known value, return the default (PriorityLevel.medium)
      return PriorityLevel.medium; // Default value
  }
}

// Enum for priority levels: high, medium, low
enum PriorityLevel { high, medium, low }

class UpdateEventUI extends StatefulWidget {
  final int index;
  final String eventName; // Event name
  final String eventDateTime; // Event date and time
  final String eventLocation; // Event location
  final String eventDescription; // Event description
  final String eventPriority; // Event priority as a string (will be converted to enum)

  // Constructor receives event data including eventPriority as a string (e.g., 'high', 'medium', 'low')
  UpdateEventUI({
    required this.index,
    required this.eventName,
    required this.eventDateTime,
    required this.eventLocation,
    required this.eventDescription,
    required this.eventPriority, // Accepting the priority as a string
  });

  @override
  _UpdateEventUIState createState() => _UpdateEventUIState();
}

class _UpdateEventUIState extends State<UpdateEventUI> {
  late TextEditingController _eventNameController;
  late TextEditingController _eventDateTimeController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventDescriptionController;
  late PriorityLevel _selectedPriority; // Priority level as an enum

  @override
  void initState() {
    super.initState();
    // Initializing controllers with the data passed from the parent widget
    _eventNameController = TextEditingController(text: widget.eventName);
    _eventDateTimeController = TextEditingController(text: widget.eventDateTime);
    _eventLocationController = TextEditingController(text: widget.eventLocation);
    _eventDescriptionController = TextEditingController(text: widget.eventDescription);

    // Converting the string passed in widget.eventPriority into the corresponding PriorityLevel enum value
    _selectedPriority = stringToPriorityLevel(widget.eventPriority); // Conversion happens here
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

        _eventDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Event", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Event Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Event Name Field
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.event, color: Colors.black45),
                labelText: "Event Name",
              ),
            ),
            const SizedBox(height: 16),

            // Event Date and Time Field
            TextField(
              controller: _eventDateTimeController,
              readOnly: true,
              onTap: () => _selectDateTime(context), // Date-time picker on tap
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.black45),
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
                suffixIcon: const Icon(Icons.location_on, color: Colors.black45),
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
                suffixIcon: const Icon(Icons.description, color: Colors.black45),
                labelText: "Event Description",
              ),
            ),
            const SizedBox(height: 16),

            // Priority Dropdown
            DropdownButtonFormField<PriorityLevel>(
              value: _selectedPriority, // The enum value is used here
              items: PriorityLevel.values.map((PriorityLevel priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last.capitalize()),
                );
              }).toList(),
              onChanged: (PriorityLevel? newValue) {
                setState(() {
                  _selectedPriority = newValue!; // When selection changes, update the priority
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

            // Buttons Row for Save and Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle event update logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Event Updated: ${_eventNameController.text}")),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // On cancel, return to the previous screen
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
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
}

// Extension to capitalize strings (e.g., "high" becomes "High")
extension StringCapitalizeExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}
```

### Summary of the Code Changes in Comments:
- **stringToPriorityLevel**: A function is used to convert a string (like `"high"`, `"medium"`, or `"low"`) into the corresponding `PriorityLevel` enum. This is essential because strings and enums are separate types in Dart, and direct assignment would cause errors.

- **PriorityLevel**: The enum defines the possible priority levels for an event (`high`, `medium`, `low`).

- **Constructor**: The `eventPriority` is now passed as a `String`, not as an enum. This allows flexibility in passing data, but it requires conversion into the enum before it's used.

- **initState**: During initialization, the string value of `eventPriority` is converted into the correct `PriorityLevel` enum using the helper function `stringToPriorityLevel`.

- **Dropdown**: The `DropdownButtonFormField` uses the `PriorityLevel` enum values. When a new value is selected, the corresponding `PriorityLevel` enum value is set.

This should give you a clear understanding of why each change was necessary and how it helps resolve the type mismatch issue. Let me know if you need further clarification!

Yes, exactly!

Currently, you are passing the **string** (e.g., `"high"`, `"medium"`, or `"low"`) to the `UpdateEventUI` screen. Then, in the `initState` method, you are converting that string into the corresponding **enum** (`PriorityLevel.high`, `PriorityLevel.medium`, or `PriorityLevel.low`) using the `stringToPriorityLevel` function.

### Here's the flow:

1. **Passing the string** (like `"high"`) to the `UpdateEventUI` screen:

```dart
UpdateEventUI(
  index: 1,
  eventName: "My Event",
  eventDateTime: "2025-01-25 10:00",
  eventLocation: "Some Location",
  eventDescription: "Event Description",
  eventPriority: "high", // Passing string here
);
```

2. **Converting the string to enum** in the `initState` method of `UpdateEventUI`:

```dart
_selectedPriority = stringToPriorityLevel(widget.eventPriority); // Convert string to enum
```

3. **Usage of the converted enum** (`_selectedPriority`) in your dropdown and other places where you need to work with the priority.

So yes, you are passing a string and then converting it into the corresponding enum in the `initState` method. This approach works perfectly if you want to pass a string and handle it as an enum inside the screen.


*/





class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;
  const VideoPlayerWidget({Key? key, required this.videoFile}) : super(key: key);

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
