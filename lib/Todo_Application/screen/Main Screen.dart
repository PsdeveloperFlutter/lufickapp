import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../Backend/Database of Application.dart';
import 'Creation_of_task.dart';
import 'Screen of Operation_update.dart';
import 'Text to speech.dart';

RxBool isshow = true.obs;

bool setcolor = false;
Color setappbarcolor = Colors.black;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.database;
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Mainscreen(),
  ));
}

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => MainscreenState();
}

class MainscreenState extends State<Mainscreen> with TickerProviderStateMixin {
  RxList<dynamic> tasks = [].obs;
  late TabController _tabController;
  Offset draggablePosition = const Offset(220, 430); // Initial position of FAB

  @override
  void initState() {
    super.initState();
    loadtasks();
    _tabController = TabController(length: 3, vsync: this);
  }

  void loadtasks() async {
    final task = await DatabaseHelper.getItems();
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
            Tab(
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              child: Text(
                "Update",
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
          child: Text(
            "ToDo App ",
            style: TextStyle(color: Colors.white, fontFamily: 'Itim', fontSize: 25),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0, top: 12),
            child: GestureDetector(
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
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                              "assets/images/IMG20240302171902.jpg"),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundImage:
                AssetImage("assets/images/IMG20240302171902.jpg"),
                radius: 20,
              ),
            ),
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
                      controller: taskNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.task),
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
              Mainpart(),
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
