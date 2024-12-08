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

RxBool isshow = true.obs;
XFile ?imageFile;

bool setcolor = false;
Color setappbarcolor = Colors.black;


TextEditingController tasksearchNameController = TextEditingController();


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
  Offset draggablePosition = const Offset(220, 430); // Initial position of FAB

  @override
  void initState() {
    super.initState();
    loadtasks();
    _tabController = TabController(length: 2, vsync: this);
  }

  void loadtasks() async {

    final task = await DatabaseHelper.getItems();

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
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context){
              return  MyApp();
            }));
          },
          child: InkWell(
             onTap:(){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp ()));
             },
            child: Text(
              "ToDo App ",
              style: TextStyle(color: Colors.white, fontFamily: 'Itim', fontSize: 25),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Profile Image"),
                  actions: <Widget>[


                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Column(
                        children: [
                          if (imageFile != null)
                            Container(
                              width: 200,
                              height: 300,
                              child: Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.fill,
                              ),
                            )
                          else
                            Text("No image selected"),
                        ],
                      ),
                    ),
                    Center(

                      child: ElevatedButton(onPressed: ()async{

                        ImagePicker picker=ImagePicker();
                        XFile? image=await picker.pickImage(
                            source: ImageSource.gallery);
                        if(image!=null){
                          setState(() {
                            imageFile=image;
                          });
                        }
                      }, child: Text("Upload Image")),
                    )
                    ,
                    Center(

                      child: ElevatedButton(onPressed: ()async{

                        ImagePicker picker=ImagePicker();
                        XFile? image=await picker.pickImage(
                            source: ImageSource.camera);
                        if(image!=null){
                          setState(() {
                            imageFile=image;
                          });
                        }
                      }, child: Text("Take Picture ")),
                    )
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right:12.0),
              child: CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: imageFile != null
                      ? Image(
                    fit: BoxFit.cover, // Ensure the image fully covers the CircleAvatar
                    image: FileImage(File(imageFile!.path)),
                  )
                      : Text("No image selected"),
                ),
              ),
            )

          )
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: tasksearchNameController,
                      decoration: InputDecoration(
                        suffixIcon:


                        InkWell(
                          onTap: () {
                            if (tasks.isEmpty) {
                              // If the tasks list is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No Task')),
                              );
                            } else if (tasksearchNameController.text.isEmpty) {
                              // If the search field is empty, restore the original list
                              tasks.assignAll(storelist); // Restore from the original backup
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Search field is empty')),
                              );
                            } else {
                              // Perform the search
                              final searchResults = tasks.where((element) {
                                final lowerCaseElement = (element['name'] ?? '').toLowerCase();
                                final lowerCaseElementdescription=(element['description'] ?? '').toLowerCase();
                                final lowerCaseSearchTerm = tasksearchNameController.text.toLowerCase();
                                return lowerCaseElement.contains(lowerCaseSearchTerm)  || lowerCaseElementdescription.contains(lowerCaseSearchTerm);
                              }).toList();

                              if (searchResults.isEmpty) {
                                // If no matches are found, restore the original list
                                tasks.assignAll(storelist); // Restore from the backup
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No tasks match your search')),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 10),
                                ListTile(
                                  title: Text(store["name"] ?? "No Name"),
                                  subtitle: Text(
                                      store["description"] ?? "No Description"),
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
                        separatorBuilder: (BuildContext context, int index) {
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
                  setappbarcolor = setcolor == false
                      ? Colors.black
                      : Colors.blue.shade700;
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
    return ExpansionTile(
      title: const Text(
        "Features",
        style: TextStyle(color: Colors.black),
      ),
      children: [
        SingleChildScrollView(
          child: Container(
            height: 550,
            child: Column(
              children: [
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
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.update, color: Colors.deepPurple),
                    title: const Text("Update"),
                    onTap: ()  {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Mainpart();
                      }));
                    },
                  ),
                ),

                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.delete, color: Colors.deepPurple),
                    title: const Text("Delete"),
                    onTap: () async {
                      await DatabaseHelper.deleteItem(store["id"]);
                      tasks.removeAt(index);
                      Get.snackbar(
                        "Task Deleted",
                        "The task '${store["name"]}' has been deleted successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
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
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading:  Icon(Icons.surround_sound, color: Colors.deepPurple),
                    title:  Text("Speak Task"),
                    //This Function and Button IS Responsible for the Text to Speech
                    onTap: ()async {
                      FlutterTts flutterTts = FlutterTts();
                      await flutterTts.setLanguage("en-US");
                      await flutterTts.setSpeechRate(0.5);
                      await flutterTts.setPitch(1.0);
                      await flutterTts.speak("${store["name"]} \n${store["description"]}\n${store["dateandtime"]}");
                    },
                    //This Function AND BODY END HERE

                  ),
                ),

              ],
            ),

          ),
        ),
      ],
    );
  }
}
