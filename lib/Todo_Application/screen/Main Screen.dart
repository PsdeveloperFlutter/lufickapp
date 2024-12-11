import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../Backend/Database of Application.dart';
import 'Creation_of_task.dart';
import 'Screen of Operation_update.dart';
import 'Splash Screen of ToDo_App.dart';
import 'package:image_picker/image_picker.dart';

bool changes = false;
bool timechanges = false;
RxBool isshow = true.obs;
RxBool mdeletion = false.obs;
XFile? imageFile;

bool setcolor = false;
Color setappbarcolor = Colors.black;

TextEditingController tasksearchNameController = TextEditingController();
TextEditingController startController = TextEditingController();
TextEditingController endController = TextEditingController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.database;
  runApp(Mainscreen());
}

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => MainscreenState();
}

class MainscreenState extends State<Mainscreen> with TickerProviderStateMixin {
  RxList<dynamic> tasks = [].obs;
  List<dynamic> storelist = [];
  late TabController _tabController;
  Offset draggablePosition = const Offset(260, 440); // Initial position of FAB

  @override
  void initState() {
    super.initState();
    loadtasks();
    _tabController = TabController(length: 2, vsync: this);
  }

  void loadtasks() async {
    final task = await DatabaseHelper.getTasks();

    storelist = List.from(task);
    setState(() {
      tasks.assignAll(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            _tabController.animateTo(index);
          },
          tabs: const [
            Tab(
              icon: Icon(
                Icons.task,
                color: Colors.white,
              ),
              child: Text(
                "Tasks",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.create,
                color: Colors.white,
              ),
              child: Text(
                "Create",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: setcolor == false
            ? setappbarcolor = Colors.black
            : setappbarcolor = Colors.blue.shade700,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          child: Text(
            "ToDo App ",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Itim', fontSize: 25),
          ),
        ),
        actions: [
          // GestureDetector on CircleAvatar for PopupMenuButton
          GestureDetector(
            onTap: () {
              // Show PopupMenu when CircleAvatar is tapped
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    100, 100, 0, 0), // Position of the menu
                items: [
                  //Change Image
                  PopupMenuItem(
                    child: Text("Change Image"),
                    onTap: () {
                      // Show dialog to select image source
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text("Select Image Source"),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  // Pick image from Gallery
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    setState(() {
                                      imageFile =
                                          image; // No changes to how XFile is handled
                                    });
                                  }
                                },
                                child: Text("Pick from Gallery"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Pick image from Camera
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (image != null) {
                                    setState(() {
                                      imageFile =
                                          image; // No changes to how XFile is handled
                                    });
                                  }
                                },
                                child: Text("Pick from Camera"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  //Time
                  PopupMenuItem(
                    child: Text("Sort by time"),
                    onTap: () async {
                      if (timechanges == false) {
                        timechanges = true;
                        Future.delayed(Duration.zero, () async {
                          tasks.sort((a, b) => b['dateandtime']
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  a['dateandtime'].toString().toLowerCase()));
                          setState(() {});
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xff0000FF),
                            content: Text(' Sorted by Ascending Order'),
                          ),
                        );
                      } else {
                        timechanges = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xff0000FF),
                            content: Text(' Sorted by Descending Order'),
                          ),
                        );

                        Future.delayed(Duration.zero, () async {
                          tasks.sort((a, b) => a['dateandtime']
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b['dateandtime'].toString().toLowerCase()));
                          setState(() {});
                        });
                      }
                    },
                  ),

                  //Description
                  PopupMenuItem(
                    child: Text("Sort by description"),
                    onTap: () async {
                      Future.delayed(Duration.zero, () async {
                        if (changes == false) {
                          tasks.sort((a, b) => b['description']
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  a['description'].toString().toLowerCase()));
                          changes = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xff0000FF),
                              content: Text(' Sorted by Descending Order'),
                            ),
                          );
                        } else {
                          tasks.sort((a, b) => a['description']
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b['description'].toString().toLowerCase()));
                          changes = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xff0000FF),
                              content: Text(' Sorted by Ascending Order'),
                            ),
                          );
                        }

                        setState(() {});
                      });
                    },
                  ),
                  //Selection from List to Delete the Task
                  PopupMenuItem(
                    child: Text("Multiple Delete"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete Tasks"),
                            content: Text("Select Range of Tasks to Delete"),
                            actions: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: startController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Start',
                                        hintText: 'Enter start index',
                                        prefixIcon:
                                            Icon(Icons.format_list_numbered)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: endController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'End',
                                        hintText: 'Enter end index',
                                        prefixIcon:
                                            Icon(Icons.format_list_numbered)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      int start =int.parse(startController.text);
                                      int end = int.parse(endController.text);
                                      start=start-1;
                                      end=end-1;
                                      if (start < tasks.length && end < tasks.length &&  start <= end) {
                                        List<dynamic> tasksToDelete =
                                            tasks.sublist(start,
                                                end + 1); // Sublist to delete

                                        for (var task in tasksToDelete) {
                                          // Assuming task contains an `id` or relevant property
                                          await DatabaseHelper.deleteTask(task[
                                              'id']); // Replace 'id' with the correct key
                                        }

                                        setState(() {
                                          tasks.removeRange(
                                              start,
                                              end +
                                                  1); // Safely remove tasks in range
                                          loadtasks(); // Reload tasks to refresh the UI
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xff0000FF),
                                            content: Text('Tasks Deleted'),
                                          ),
                                        );

                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xff0000FF),
                                            content: Text('Enter valid index'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text("Delete"),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Add your delete logic here

                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: imageFile != null
                      ? Image.file(
                          File(imageFile!.path),
                          fit: BoxFit
                              .cover, // Ensures the image fills the CircleAvatar
                        )
                      : Image.asset(
                          "assets/images/IMG20240302171902.jpg",
                          fit: BoxFit.cover, // Default image if none selected
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: tasksearchNameController,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            if (tasks.isEmpty) {
                              // If the tasks list is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No Task')),
                              );
                            } else if (tasksearchNameController.text.isEmpty) {
                              // If the search field is empty, restore the original list
                              tasks.assignAll(
                                  storelist); // Restore from the original backup
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Search field is empty')),
                              );
                            } else {
                              // Perform the search
                              final searchResults = tasks.where((element) {
                                final lowerCaseElement =
                                    (element['name'] ?? '').toLowerCase();
                                final lowerCaseElementdescription =
                                    (element['description'] ?? '')
                                        .toLowerCase();
                                final lowerCaseSearchTerm =
                                    tasksearchNameController.text.toLowerCase();
                                return lowerCaseElement
                                        .contains(lowerCaseSearchTerm) ||
                                    lowerCaseElementdescription
                                        .contains(lowerCaseSearchTerm);
                              }).toList();

                              if (searchResults.isEmpty) {
                                // If no matches are found, restore the original list
                                tasks.assignAll(
                                    storelist); // Restore from the backup
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('No tasks match your search')),
                                );
                              } else {
                                // Update tasks with the search results
                                tasks.assignAll(searchResults);
                              }
                            }
                          },
                          child: const Icon(Icons.search),
                        ),
                        hintText: "Search Your Task",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return tasks.isEmpty
                          ? const Center(child: Text("No Tasks"))
                          : ListView.separated(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                var store = tasks[index];
                                return Card(
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 10),
                                      ListTile(
                                        title: Text(store["name"] ?? "No Name"),
                                        subtitle: Text(store["description"] ??
                                            "No Description"),
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isshow.value = !isshow.value;
                                            });
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        ),
                                      ),
                                      Obx(() {
                                        return Offstage(
                                          offstage: isshow.value,
                                          child: functionality(store, index),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  color: Colors.deepOrangeAccent.withAlpha(20),
                                  thickness: 10,
                                );
                              },
                            );
                    }),
                  ),
                ],
              ),
              create(),
            ],
          ),
          Positioned(
            left: draggablePosition.dx,
            top: draggablePosition.dy,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  setcolor = !setcolor;
                  setappbarcolor =
                      setcolor == false ? Colors.black : Colors.blue.shade700;
                });
              },
              backgroundColor: setappbarcolor,
              child: const Icon(
                size: 20,
                Icons.colorize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget functionality(dynamic store, int index) {
    return SingleChildScrollView(
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              Icons.more_vert,
              color: Colors.deepPurple,
            ),
            const Text(
              "Options",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        children: [
          Container(
            height: 640, // Set height to make the scrollable area manageable
            child: Column(
              children: [
                // Show Image
                Card(
                  elevation: 5,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Icon(Icons.image, color: Colors.deepPurple),
                        SizedBox(width: 12),
                        Text("Show Image"),
                      ],
                    ),
                    children: [
                      store["imagePath"] == null
                          ? const Text("No Image")
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            width: 300,
                            height: 300, // Limit the size of the image
                            child: Image.file(File(store["imagePath"] ?? " ")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Done Option
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.done, color: Colors.deepPurple),
                    title: const Text("Done"),
                    onTap: () async {
                      await DatabaseHelper.deleteTask(store["id"]);
                      tasks.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xff4796ff),
                          content: Text('Task Done'),
                        ),
                      );
                    },
                  ),
                ),

                // Share Option
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.share, color: Colors.deepPurple),
                    title: const Text("Share"),
                    onTap: () {
                      Share.share(
                          "Task: ${store["name"]}\nDescription: ${store["description"]}");
                    },
                  ),
                ),

                // Update Option
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.update, color: Colors.deepPurple),
                    title: const Text("Update"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Mainpart(id: store["id"], index: index, tasks: tasks);
                      }));
                    },
                  ),
                ),

                // Delete Option
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.delete, color: Colors.deepPurple),
                    title: const Text("Delete"),
                    onTap: () async {
                      await DatabaseHelper.deleteTask(store["id"]);
                      tasks.removeAt(index);
                      Get.snackbar(
                        "Task Deleted",
                        "The task '${store["name"]}' has been deleted successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),

                // Copy and Paste
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.copy_all, color: Colors.deepPurple),
                    title: const Text("Copy and Paste"),
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                          "Task: ${store["name"]}\nDescription: ${store["description"]}",
                        ),
                      ).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      });
                    },
                  ),
                ),

                // Speak task
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.surround_sound, color: Colors.deepPurple),
                    title: Text("Speak Task"),
                    onTap: () async {
                      FlutterTts flutterTts = FlutterTts();
                      await flutterTts.setLanguage("hi-IN");
                      await flutterTts.setSpeechRate(0.5);
                      await flutterTts.setPitch(1.0);
                      await flutterTts.speak(
                          "${store["name"]} \n${store["description"]}\n${store["dateandtime"]}");
                    },
                  ),
                ),

                // Archive task
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.archive, color: Colors.deepPurple),
                    title: Text("Archive Task"),
                    onTap: () async {},
                  ),
                ),

                // Pdf task
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.deepPurple),
                    title: Text("Pdf Task"),
                    onTap: () async {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }





}
