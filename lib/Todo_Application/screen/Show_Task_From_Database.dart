//This is the Main Part of the Show task From Database of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lufickapp/Todo_Application/Backend/Database%20of%20Application.dart';
import 'package:sqflite/sqflite.dart';

import 'Main Screen.dart';

//This is for Showing the List of the Tasks
RxList<dynamic> taskList = [
  {
    "taskName": "Task 1",
    "taskDescription": "Description 1",
  }
  ,
  {
    "taskName": "Task 2",
    "taskDescription": "Description 2",
  }
  ,{
    "taskName": "Task 3",
    "taskDescription": "Description 3",
  }
  ,{
    "taskName": "Task 4",
    "taskDescription": "Description 4",
  }
  ,
{
"taskName": "Task 5",
"taskDescription": "Description 5",
},
  {
    "taskName": "Task 6",
    "taskDescription": "Description6",
  }

].obs;

class showTaskpart extends StatefulWidget {
  @override
  State<showTaskpart> createState() => showTaskpartState();
}

class showTaskpartState extends State<showTaskpart> {

  //Instance of It
  MainscreenState _mainScreenState=MainscreenState();


  //Show Task Part from Database
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _mainScreenState.tasks.length,
      itemBuilder: (context, index) {
        var store=_mainScreenState.tasks[index];
        return Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(store["taskName"]),
                  subtitle: Text(store["taskDescription"]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
