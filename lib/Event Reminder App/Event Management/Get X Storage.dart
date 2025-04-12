import 'package:flutter/material.dart';
import'package:get_storage/get_storage.dart';
final GetStorage storage=GetStorage();

void saveEvent(Map<String, dynamic> event, BuildContext context) {
  try {
    print("Code run here successfully");

    // Retrieve the current list from savedEvents
    List<dynamic>? savedEventsDynamic = storage.read('savedEvent');

    // Explicitly cast the retrieved data to List<Map<String, dynamic>>
    List<Map<String, dynamic>> savedEvent = (savedEventsDynamic ?? [])

        .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)

        .toList();

    // Add the new event to the list
    savedEvent.add(event);

    // Write the updated list back to storage
    storage.write('savedEvents', savedEvent);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5), // Optional: customize duration
        content: Row(
          children: const [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
            SizedBox(width: 16),
            Text("Data Backup successfully!"),
          ],
        ), // Optional styling
        behavior: SnackBarBehavior.floating, // Optional: floating effect
      ),
    );

  } catch (e) {
    // Log the exception and rethrow it
    print("Exception occurred: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save data: $e")),
    );
    throw Exception("Data is not saved successfully");
  } finally {
    print("Code run here successfully");
  }
}//Retrieve list from the Get X storage
List<Map<String,dynamic>>getSavedEvents(){
  return storage.read('savedEvents');
}


//In which We are first check the list and after that convert the List datatype and after that we add the data in getX storage
