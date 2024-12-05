// This is the Main Part of Our Flutter Applications
//This is the Main Part of the Create of task in Our Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class create extends StatelessWidget {
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}