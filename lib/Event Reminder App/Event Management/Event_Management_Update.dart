// Extension to convert string to enum
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

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

  UpdateEventUI({required this.index,
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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
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
//This is configuration code of notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    // Initialize timezone database
    tzData.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(DateTime scheduledTime,
      String message,
      String name,
      String location,
      String description,) async {
    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledTZDateTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      '$name', // Notification Title
      '$description', // Notification Body
      scheduledTZDateTime, // Scheduled Time
      platformChannelSpecifics, // Notification Details
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  //Here is Build Method
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
                    Text(priority
                        .toString()
                        .split('.')
                        .last
                        .capitalize()),
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
              //Here we set the Notification Updation code
              Text(
                "Update Notification",
                style: GoogleFonts.aBeeZee(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  hintText: 'Tap to choose a date',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.0,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blue,
                          colorScheme: ColorScheme.light(primary: Colors.blue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Time',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  hintText: 'Tap to choose a time',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: Icon(
                    Icons.access_time,
                    color: Colors.blue,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.0,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blue,
                          colorScheme: ColorScheme.light(primary: Colors.blue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.imagepath != null
                      ? Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: seefile(widget.imagepath)),
                  )
                      : Center(
                    child: Text(
                      "No image selected",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      label: Text(
                        widget.imagepath != null
                            ? "Upload another Image"
                            : "Upload Image",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () async {
                        UploadImage();
                      },
                      icon: Icon(
                        Icons.track_changes_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.filepath != null
                      ? Center(
                    child: Container(
                        height: 100,
                        width: 100,
                        child: seefile(widget.filepath)),
                  )
                      : Center(
                    child: Text(
                      "No file selected",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      label: Text(
                        widget.filepath != null
                            ? "Upload another file"
                            : "Upload file",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () async {
                        getFile();
                      },
                      icon: Icon(
                        Icons.track_changes_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.videopath != null
                      ? Center(
                    child: Container(
                        height: 40,
                        width: 140,
                        child: seefile(widget.videopath)),
                  )
                      : Text(
                    "No video selected",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      label: Text(
                        widget.videopath == null
                            ? "Upload Video"
                            : "Upload another Video",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () async {
                        getvideo();
                      },
                      icon: Icon(
                        Icons.track_changes_outlined,
                        color: Colors.red,
                      ),
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
                      updatefunctionality();
                      if (selectedTime != null && selectedDate != null) {
                        _scheduleNotification();
                      }
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

  //This is the code of the Schedule Notification Functionality
  void _scheduleNotification() {
    if (widget.eventName.isEmpty ||
        widget.eventLocation.isEmpty ||
        widget.eventDescription.isEmpty ||
        widget.eventPriority.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all event details')),
      );
      return;
    }
    final scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final formattedDate =
    DateFormat('dd-MM-yyyy – kk:mm').format(scheduledDateTime);

    // Call the Schedule Notification Function
    scheduleNotification(scheduledDateTime, 'Notification at $formattedDate',
        widget.eventName, widget.eventLocation, widget.eventDescription);
    // Show the result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for $formattedDate')),
    );
  }

  //This is the code of Update functionality
  void updatefunctionality() async {
    final DatabaseHelper database = await DatabaseHelper.instance;
    final Map<String, dynamic> data = {
      'name': _eventNameController.text,
      'date_time': _eventDateTimeController.text,
      'location': _eventLocationController.text,
      'description': _eventDescriptionController.text,
      'priority': _selectedPriority
          .toString()
          .split('.')
          .last,
      'image_path': widget.imagepath,
      'file_path': widget.filepath,
      'video_path': widget.videopath
    };
    //This is for the Show Result of Updation of the Data
    database.updateEvent(data, widget.id).then((value) =>
    {
      print("Event updated successfully!"),
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event updated successfully!"))),
      Timer(Duration(seconds: 2), () => Navigator.pop(context)),
    });
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateTimeController.dispose();
    _eventLocationController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  //This is for see the File
  Widget seefile(String filepath) {
    File file = File(filepath);
    if (!file.existsSync()) {
      return Center(
        child: Text(
          "File not found!",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
    } else if (["pdf"].contains(file.path
        .split('.')
        .last)) {
      // Display PDF
      return PDFViewWidget(context, filePath: filepath);
    } else if (["jpg", "jpeg", "png"].contains(file.path
        .split('.')
        .last)) {
      // Display Image
      return Image.file(
        file,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }
    return Center(
      child: Text("video Selected",
          style: TextStyle(fontSize: 15, color: Colors.black)),
    );
  }

  //This code for uploading the image
  void UploadImage() async {
    ImagePicker image = ImagePicker();
    XFile? file = await image.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        widget.imagepath = file.path;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image uploaded successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image not uploaded")));
    }
  }

  //This is for Getting file from user
  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        widget.filepath = result.files.single.path;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("File uploaded successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("File not uploaded")));
    }
  }

//This is for getting the video from user
  void getvideo() async {
    ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickVideo(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        widget.videopath = result.path;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Video uploaded successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Video not uploaded")));
    }
  }
}

// Extension to capitalize strings
extension StringCapitalizeExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

//This is for showing th pdf file
Widget PDFViewWidget(BuildContext context, {required String filePath}) {
  return PDFView(
    filePath: filePath,
    enableSwipe: true,
    swipeHorizontal: false,
    autoSpacing: true,
  );
}
