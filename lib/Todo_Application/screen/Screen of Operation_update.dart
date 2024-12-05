//This is the Main Part of the Updation of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Main Screen.dart';

Widget Mainpart() {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 20),
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
        const SizedBox(height: 20),


        Padding(
          padding: const EdgeInsets.only(left: 180.0),
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black,elevation: 4),
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    ),
  );
}
