//This is the Main Part of the Show task From Database of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

//Show Task Part from Database
Widget showTaskpart() {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: taskList.length,
    itemBuilder: (context, index) {
      return Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text(taskList[index]["taskName"]),
                 subtitle: Text(taskList[index]["taskDescription"]),
               ),
             ),
          ],
        ),
      );
    },
  );
}
