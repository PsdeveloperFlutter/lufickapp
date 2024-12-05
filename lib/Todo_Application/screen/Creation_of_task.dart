// This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

Rx<DateTime> selectedDate = DateTime.now().obs;

// Controllers for text fields
TextEditingController taskNameController = TextEditingController();
TextEditingController dateTimeController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();

Widget creationpart(BuildContext context) {
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
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dateTimeController.text = ('\${pickedDate.day.toString().padLeft(2, 0)}-\${pickedDate.month.toString().padLeft(2, 0)}-\${pickedDate.year}');
                    }
                  },
                  child: TextField(
                    controller: dateTimeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      labelText: 'Pick Date and Time',
                      hintText: 'Pick Date and Time',
                    ),
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: taskDescriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
              labelText: 'Task Description',
              hintText: 'More details about the task',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            onPressed: () {
              // Add your update logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 4,
            ),
            child: Text(
              "Create Task",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}


