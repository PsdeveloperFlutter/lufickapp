//This is the Main Part of the Show task From Database of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//This is for Showing the List of the Tasks
RxList<dynamic> taskList = ["hello"].obs;

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
                 title: Text(taskList[index]),
               ),
             ),
          ],
        ),
      );
    },
  );
}
