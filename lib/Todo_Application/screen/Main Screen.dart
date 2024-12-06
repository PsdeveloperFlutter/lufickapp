import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Backend/Database of Application.dart';
import 'Creation_of_task.dart';
import 'Screen of Operation_update.dart';

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
  //THIS FUNCTION RELATED TO DATABASE OF SQFLITE DATABASE

  //RxList Dynamic
  RxList<dynamic> tasks = [].obs;

  late TabController _tabController;

  void initState() {
    super.initState();
    loadtasks();
    _tabController = TabController(length: 3, vsync: this);
  }

  //Retrive the data from the Database
  void loadtasks() async {
    final task = await DatabaseHelper.getItems();
    setState(() {
      tasks.assignAll(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            setcolor = !setcolor;
          });
        },
        backgroundColor: setcolor == false
            ? setappbarcolor = Colors.black
            : setappbarcolor = Colors.blue.shade700,
        child: const Icon(
          size: 20,
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            _tabController.animateTo(index);
          },
          tabs: [
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
        title: const Text(
          "ToDo App ",
          style:
              TextStyle(color: Colors.white, fontFamily: 'Itim', fontSize: 25),
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
              child: CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/IMG20240302171902.jpg"),
                radius: 20, // adjust the radius to your desired size
              ),
            ),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //This is Show the Task from Database in Main Screen

          Obx(() {
            return tasks.isEmpty
                ? Center(child: Text("No Tasks"))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var store = tasks[index];
                      return Card(
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(store["name"] ?? "No Name"),
                                subtitle: Text(
                                    store["description"] ?? "No Description"),
                                trailing: Checkbox(
                                  value: store["completed"] == 1,
                                  onChanged: (value) async {
                                    await DatabaseHelper.updateItem(
                                      store["id"],
                                    );
                                    loadtasks();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }),

          //This is code of the Creation of the Task
          create(),
          //This the Updation Part of Our Flutter Applications
          Mainpart(),
        ],
      ),
    );
  }
}
