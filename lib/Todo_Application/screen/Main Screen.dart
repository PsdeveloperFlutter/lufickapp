import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Backend/Database of Application.dart';
import 'Creation_of_task.dart';
import 'Screen of Operation_update.dart';
import 'Show_Task_From_Database.dart';

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

class MainscreenState extends State<Mainscreen> {

//THIS FUNCTION RELATED TO DATABASE OF SQFLITE DATABASE

  //RxList Dynamic
  RxList <dynamic> tasks=[].obs;

  void initState() {
    super.initState();
    loadtasks();
  }


  //Retrive the data from the Database
  void loadtasks()
  async{
    final task=await DatabaseHelper.getItems();
    setState(() {
      tasks.value=task;
    });
  }




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {},
          child: const Icon(
            size: 20,
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          bottom:  const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.task,
                  color:Colors.white,
                ),
                child: Text("Tasks",style: TextStyle(color: Colors.white),),
              ),
              Tab(
                icon: Icon(
                  Icons.create,
                  color: Colors.white,
                ),
                child: Text("Create",style: TextStyle(color: Colors.white),),
              ),
              Tab(
                icon: Icon(
                  Icons.update,
                  color: Colors.white,
                ),
                child: Text("Update",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          title: const Text(
            "ToDo App ",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Itim', fontSize: 25),
          ),
        ),
        body: TabBarView(
          children: [
         //This is Show the Task from Database in Main Screen
            showTaskpart(),
         //This is code of the Creation of the Task
            create(),
          //This the Updation Part of Our Flutter Applications
            Mainpart(),
          ],
        ),
      ),
    );
  }
}



