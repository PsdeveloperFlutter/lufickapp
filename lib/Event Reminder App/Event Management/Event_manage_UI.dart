import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:video_player/video_player.dart';

import '../Riverpod_Management/Riverpod_add_Management.dart';
// Main application class
void main() {
  runApp(ProviderScope(child: Mainpage_event_management()));
}

List<String> categories = ['Work', 'Personal', 'Meeting', 'Birthday', 'Other'];
class Mainpage_event_management extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.music_note, color: Colors.white)),
                Tab(icon: Icon(Icons.music_video, color: Colors.white)),
                Tab(icon: Icon(Icons.camera_alt, color: Colors.white)),
                Tab(icon: Icon(Icons.grade, color: Colors.white)),
                Tab(icon: Icon(Icons.email, color: Colors.white)),
              ],
            ),
            title: const Text(
              'Event Reminder App',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
          body: TabBarView(
            children: [
              const Center(child: Icon(Icons.music_note, size: 50)),
              EventCreationUI(),
              const Center(child: Icon(Icons.camera_alt, size: 50)),
              const Center(child: Icon(Icons.grade, size: 50)),
              const Center(child: Icon(Icons.email, size: 50)),
            ],
          ),
        ),
      ),
    );
  }
}








// Widget for Event Creation UI
class EventCreationUI extends ConsumerStatefulWidget {
  @override
  _EventCreationUIState createState() => _EventCreationUIState();
}

class _EventCreationUIState extends ConsumerState<EventCreationUI> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateTimeController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  // Function to pick date and time
  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _eventDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final XFile? selectedImage = ref.watch(imageprovider);
    final VideoPlayerController? videoController = ref.watch(videoControllerProvider.select((value) => value));
    final PlatformFile? selectedFile = ref.watch(fileProvider);
    // Watch the state of the radio button provider
    final selectedPriority = ref.watch(radioButtonProvider);


    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the form
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Create an Event",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "\nTo be Reminded",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),

            // Event Name Field
            _buildTextField(_eventNameController, "Event Name", Icons.event),

            const SizedBox(height: 16),

            // Event Date and Time Field
            GestureDetector(
              onTap: () => _selectDateTime(context),
              child: AbsorbPointer(
                child: _buildTextField(_eventDateTimeController, "Event Date and Time", Icons.calendar_today),
              ),
            ),

            const SizedBox(height: 16),

            // Event Location Field
            _buildTextField(_eventLocationController, "Event Location", Icons.location_on),

            const SizedBox(height: 16),

            // Event Description Field
            _buildTextField(_eventDescriptionController, "Event Description", Icons.description, maxLines: 3),

            const SizedBox(height: 12),

            //Expansion Title Widget for Managing the Category of the Event

            ExpansionTile(title: const Text("Category",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20,fontWeight: FontWeight.bold),),
            children: [
              Container(
                width: 300,
                height: 180,
                child: ListView.builder(itemBuilder: (context,index){
                  return
                    GestureDetector(
                      onTap: (){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You Select ${categories[index]}Category")));
                      },
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(categories[index],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          trailing: Icon(Icons.select_all),
                        ),
                      ),
                    );
                },itemCount: categories.length,),
              ),
            ]),

            Padding(
              padding: const EdgeInsets.only(left:26.0),
              child: Text("Priority",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            )
            // Radio Button
            ,
            SizedBox(height: 5,),
            Row(
              children: [
                Radio<PriorityLevel>(
                  value: PriorityLevel.high,
                  groupValue: selectedPriority,
                  onChanged: (PriorityLevel? value) {
                    // Update the state using the provider's notifier
                    ref.read(radioButtonProvider.notifier).state = value;
                  },
                ),
                const Text("High"),

                Radio<PriorityLevel>(
                  value: PriorityLevel.medium,
                  groupValue: selectedPriority,
                  onChanged: (PriorityLevel? value) {
                    // Update the state using the provider's notifier
                    ref.read(radioButtonProvider.notifier).state = value;
                  },
                ),
                const Text("Medium"),

                Radio<PriorityLevel>(
                  value: PriorityLevel.low,
                  groupValue: selectedPriority,
                  onChanged: (PriorityLevel? value) {
                    // Update the state using the provider's notifier
                    ref.read(radioButtonProvider.notifier).state = value;
                  },
                ),
                const Text("Low"),
              ],
            ),

            // Display the selected option

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Selected Priority: ${selectedPriority?.name}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),


            const SizedBox(height: 16),
            // Media Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMediaButton(Icons.photo_album, "Photo", () => _pickImage(context)),
                _buildMediaButton(Icons.video_call,"Video" , () => _pickVideo(context)),
                _buildMediaButton(Icons.file_copy,"File", () => _pickFile(context)),
              ],
            ),

            const SizedBox(height: 12),

            // Display Selected Image
            selectedImage != null
                ? Image.file(File(selectedImage.path), height: 100, width: 100, fit: BoxFit.cover)
                : Container(height: 100, width: 100, color: Colors.grey),

            //Display Selected Video

    videoController != null && videoController.value.isInitialized
        ? AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
    )
        : const Text("No video selected"),




            //Display Selected File
            // Display Selected File
            selectedFile != null
                ? Text("File Selected: ${selectedFile.name}")
                : Text("No file selected"),


          ],
        ),

      ),
    );
  }








  //This is for the Managing the Image
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ref.read(imageprovider.notifier).state = image;
    }
  }

  //This is for the Managing the Video
  Future<void> _pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      ref.read(videoControllerProvider.notifier).setVideo(video);
    }
  }


  //This is for the Manging the File
  // Function to pick a file
  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      // Updating the provider state
      ref.read(fileProvider.notifier).state = file;
    }
  }

}























//Custom Components

//This is for managing the Text Field
Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: Icon(icon, color: Colors.blue.shade700
      ),
      hintText: "Enter $label",
      label: Text(label),
    ),
  );
}


//This is for the Managing the Video and image make sure of that
Widget _buildMediaButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    children: [
      IconButton(onPressed: onPressed, icon: Icon(icon, color: Colors.deepOrange)),
      Text(label, style: TextStyle(color: Colors.deepPurple))
    ],
  );
}





