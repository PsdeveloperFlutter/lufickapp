import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';

import '../Backend/Database of Application.dart';
import 'Main Screen.dart';
import 'Particles_Flutter.dart';

XFile? imagefilestore;
XFile? videofilestore;

class create extends StatefulWidget {
  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateTimeController.text = "${selectedDate.value.day}-${selectedDate.value.month}-${selectedDate.value.year}";
  }

  // Method to add a task to the database
  void addTask() async {
    if (taskNameController.text.isEmpty || taskDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await DatabaseHelper.insertTask({
      'name': taskNameController.text,
      'description': taskDescriptionController.text,
      'dateandtime': dateTimeController.text,
      'imagePath': imagefilestore?.path.toString() ?? '',  // Use an empty string if the image is not selected
      'videoPath': videofilestore?.path ?? '',
    });



    print("Task Added");
      // Navigate to the MainScreen after task creation
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mainscreen()));
    } catch (e) {
      print("Error adding task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    taskNameController.dispose();
    dateTimeController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "What needs to be done?",
                  prefixIcon: Icon(Icons.list_alt_rounded),
                  prefixIconColor: Colors.green.shade700,
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: dateTimeController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Date and Time",
                  prefixIconColor: Colors.green.shade700,
                  prefixIcon: Icon(Icons.date_range),
                  labelText: 'Date and Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    selectedDate.value = picked;
                    dateTimeController.text = "${picked.day}-${picked.month}-${picked.year}";
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: taskDescriptionController,
                decoration: InputDecoration(
                  prefixIconColor: Colors.green.shade700,
                  hintText: "More details about the task",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 15),

              // Image Upload Section
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Select Option"),
                      content: const Text(
                        "Choose from Gallery and Camera",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      actions: <Widget>[
                        SingleChildScrollView(
                          child: Container(
                            width: 250,
                            height: 100,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () async {
                                    final XFile? image =
                                    await ImagePicker().pickImage(source: ImageSource.camera);
                                    if (image != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Selected")));

                                      setState(() {
                                        imagefilestore = image;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Camera",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () async {
                                    final XFile? image =
                                    await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Selected")));
                                      setState(() {
                                        imagefilestore = image;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Gallery",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.green.shade700,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Offstage(
                      offstage: imagefilestore == null,
                      child: SingleChildScrollView(
                        scrollDirection:  Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Image Uploaded: ${imagefilestore?.name}",
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  imagefilestore = null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Image Removed")));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Video Upload Section
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Select Option"),
                      content: const Text(
                        "Choose from Gallery and Camera",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      actions: <Widget>[
                        SingleChildScrollView(
                          child: Container(
                            width: 250,
                            height: 60,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () async {
                                    final XFile? video =
                                    await ImagePicker().pickVideo(source: ImageSource.gallery);
                                    if (video != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video Selected")));
                                      setState(() {
                                        videofilestore = video;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Select Video",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.video_call,
                          color: Colors.green.shade700,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Upload Video ',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Offstage(
                      offstage: videofilestore == null,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Video Uploaded: ${videofilestore?.name}",
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  videofilestore = null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Video Removed")));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 148.0, top: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: addTask,
                  child: Text(
                    'Create Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
