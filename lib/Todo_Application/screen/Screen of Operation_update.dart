//This is the Main Part of the Updation of Our Flutter Applications
//This is the Main Part of Our Flutter Applications
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



TextEditingController taskNameController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();
TextEditingController dateTimeController = TextEditingController();

class Mainpart extends StatefulWidget {

  @override
  State<Mainpart> createState() => _MainpartState();
}

final Rx<DateTime> selectedDate = DateTime.now().obs;
class _MainpartState extends State<Mainpart> {
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 8),
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
                    dateTimeController.text = "${picked.day}-${picked.month}-${picked.year}";
                  }
                },
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
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, elevation: 4),
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ))
            
          ],
        ),
      ),
    );
  }
}
