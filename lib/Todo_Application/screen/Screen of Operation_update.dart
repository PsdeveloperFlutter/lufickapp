//This is the Main Part of the Updation of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
XFile ? imagefilestoreS;
XFile ? videofilestoreS;

TextEditingController taskNameController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();
TextEditingController dateTimeController = TextEditingController();

class Mainpart extends StatefulWidget {

  @override
  State<Mainpart> createState() => _MainpartState();
}

final Rx<DateTime> selectedDate = DateTime.now().obs;
class _MainpartState extends State<Mainpart> {

  @override
  void initState() {
    super.initState();
    dateTimeController.text = "${selectedDate.value.day}-${selectedDate.value.month}-${selectedDate.value.year}";
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Update Task",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: taskNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.list_alt_rounded),
                  border: OutlineInputBorder(),
                  labelText: 'Task Name',
                  hintText: 'What needs to be done?',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: dateTimeController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Date and Time",
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
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: taskDescriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  labelText: 'Task Description',
                  hintText: 'More details about the task',
                ),
              ),
            ),
            const SizedBox(height: 8),



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
                                      imagefilestoreS = image;
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
                                      imagefilestoreS = image;
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
                    offstage: imagefilestoreS == null,
                    child: SingleChildScrollView(
                      scrollDirection:  Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Image Uploaded: ${imagefilestoreS?.name}",
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                imagefilestoreS = null;
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
                                      videofilestoreS = video;
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
                    offstage: videofilestoreS == null,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Video Uploaded: ${videofilestoreS?.name}",
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                videofilestoreS = null;
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



            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, elevation: 4),
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ))

          ],
        ),
      ),
    ),
    );
  }
}
