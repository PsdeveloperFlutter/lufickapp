// This is the Main Part of Our Flutter Applications
//This is the Main Part of the Create of task in Our Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../Backend/Database of Application.dart';
import 'Main Screen.dart';

class create extends StatefulWidget {
  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController dateTimeController = TextEditingController();

  final TextEditingController taskDescriptionController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "What needs to be done?",
                  prefixIcon: Icon(Icons.list_alt_rounded),
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(

                controller: dateTimeController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Date and Time",
                  prefixIcon: Icon(Icons.date_range),
                  labelText: 'Date and Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    selectedDate.value = picked;
                    dateTimeController.text = selectedDate.value.toString().split(' ')[0];
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(

                controller: taskDescriptionController,
                decoration: InputDecoration(
                  hintText: "More details about the task",
                    hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 15,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  // Handle task creation logic here






                  //This is Responsible for adding the task to Sqflite Database
                  void addtask() async{
                    await DatabaseHelper.insertItem({
                      'name':taskNameController.text,
                      'description':taskDescriptionController.text,
                      'dateandtime':dateTimeController.text
                    });

                    MainscreenState _mainScreenState = MainscreenState();
                    _mainScreenState.loadtasks();
                  }

                  //This is the Function for Handling the Creation of the Task and Responsible For Adding Data of Task into Database
                 addtask();

                },
                child: Text('Create Task',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}