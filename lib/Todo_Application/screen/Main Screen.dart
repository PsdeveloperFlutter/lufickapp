import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Creation_of_task.dart';
import 'Screen of Operation_update.dart';
import 'Show_Task_From_Database.dart';

TextEditingController taskNameController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();
TextEditingController dateTimeController=TextEditingController();
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Mainscreen(),
  ));
}

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
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



