
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Main Screen.dart';

Widget Mainpart() {

  return  SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding:  EdgeInsets.all(10.0),
          child: TextField(
            controller: taskNameController,
            decoration:  InputDecoration(
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
            maxLines: 8,

            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
              labelText: 'Task Description',
              hintText: 'More details about the task',
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
