import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:lufickapp/Event%20Reminder%20App/Controller%20of%20App/Controller1.dart';
import 'package:lufickapp/Event%20Reminder%20App/Database/Main_Database_App.dart';
import 'package:lufickapp/Event%20Reminder%20App/Event%20Management/Get%20X%20Storage.dart';
import 'package:lufickapp/Event%20Reminder%20App/NotificationCode/UI_Notification/SecondUIofNotifications.dart';
import 'package:video_player/video_player.dart';
import '../Getx Storage/Them e Change getxController.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom Tags Class .dart';
import 'Event_List_Screen.dart';
// Main application class

XFile? image;
XFile? video;
PlatformFile? file;
void main() {
  runApp(ProviderScope(child: Mainpage_event_management()));
}
final ThemeController themeController = Get.put(ThemeController()); // Inject Controller
List<String> categories = ['Work', 'Personal', 'Meeting', 'Birthday'];

class Mainpage_event_management extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(


        appBar: AppBar(
          toolbarHeight: 30,
          actions: [
            IconButton(onPressed: (){
              final ThemeController themeController = Get.find();
              themeController.toggletheme();
            }, icon: Icon(themeController.changemode==1?Icons.nightlight_round:Icons.wb_sunny_outlined,color:themeController.changemode==1?Colors.grey.shade900:Colors.yellow.shade500)),
            IconButton(onPressed: (){

              //Logic Here of Retrieve of data from GetxStorage and show send in database

              //First of Retrieve the data from Get X Storage and after send the data to database

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer(builder: (context,ref,child){
                    return AlertDialog(
                      title: const Text('Retrieve Data'), // Your title here
                      content: const Text('Are you sure you want to retrieve data.'), // Your content here
                      actions: <Widget>[ // Buttons at the bottom
                        TextButton(
                          onPressed: () {

                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async{
                            // Do something else, like process data

                            print(getSavedEvents());
                            var data= getSavedEvents();
                            DatabaseHelper obj=await DatabaseHelper.instance;
                            //Here getSavedEvents give us data in the form of List<Map<String,dynamic>> and through this we convert the List<Map<String,dynamic>> to Map<String,dynamic>
                            for(var event in data){
                              await obj.insertEvent(event);
                            }
                            Navigator.pop(context);
                            ref.invalidate(eventsProvider);

                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  });
                },
              );



            }, icon: Icon(Icons.restart_alt,color: Colors.blue.shade500,))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.event,color: Colors.green),),
              Tab(icon: Icon(Icons.create,color: Colors.green,)),
            ],
          ),
          title:Text(
            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 15),
            'Event Reminder App',
          ),
        ),
        body: TabBarView(
          children: [
            EventsScreen(),
            EventCreationUI(),
          ],
        ),
      ),
    );
  }
}








// Widget for Event Creation UI
class EventCreationUI extends ConsumerStatefulWidget {
  @override
  EventCreationUIState createState() => EventCreationUIState();
}

class EventCreationUIState extends ConsumerState<EventCreationUI> {
 TextEditingController _controllerpriority = TextEditingController();//Controller for the Priority Selection make sure of that
  dynamic categoriesvalue;
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

        bool is24HourFormat =MediaQuery.of(context).alwaysUse24HourFormat;

        _eventDateTimeController.text = DateFormat(is24HourFormat ? 'dd-MM-yyyy HH:mm' : 'dd-MM-yyyy hh:mm a').format(combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // // Watch the state of the radio button provider
    var selectedPriority = ref.watch(radioButtonProvider);


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
                    text: TextSpan(
                      text: "Create an Event",
                      style: GoogleFonts.poppins(
                          color: Colors.deepOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),

                      children:  [
                        TextSpan(
                          text: "\nTo be Reminded",
                          style: GoogleFonts.poppins(
                            color: Colors.blue.shade700,
                            fontSize: 15
                          ),
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

            const SizedBox(height: 16),


            SizedBox(height: 16,),

            CustomTagsWidget(),

            SizedBox(height: 14,),



            //set the Notifications
            TextButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return NotificationScreen(
              name: _eventNameController.text.toString(),
              category: categoriesvalue.toString(),
              location: _eventLocationController.text.toString(),
              description: _eventDescriptionController.text.toString(),
               priority: selectedPriority.toString(),

             );
           }));




            }, child: Text("Schedule Notification",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800
                ),)),


            SizedBox(height: 16,),




            TextField(
              controller: _controllerpriority,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Priority',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26.0),
                  child: Text("Priority", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                ),

                SizedBox(width: 18),

                DropdownButton<PriorityLevel>(
                  hint: Text("Select Priority", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                  value: selectedPriority,
                  items: PriorityLevel.values.map((priority) {
                    return DropdownMenuItem<PriorityLevel>(
                      value: priority,
                      child: Row(
                        children: [
                          Radio<PriorityLevel>(
                            value: priority,
                            groupValue: selectedPriority,
                            onChanged: (PriorityLevel? value) {
                              if (value != null) {
                                setState(() {
                                  selectedPriority = value;
                                  _controllerpriority.text = value.name.toUpperCase(); // Update TextField with selected value
                                });
                                ref.read(radioButtonProvider.notifier).state = value;
                              }
                            },
                          ),
                          Text(priority.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (PriorityLevel? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPriority = newValue;
                        _controllerpriority.text = newValue.name.toUpperCase(); // Update TextField
                      });
                      ref.read(radioButtonProvider.notifier).state = newValue;
                    }
                  },
                ),
              ],
            ),

            // Row(
            //   children: [
            //     Radio<PriorityLevel>(
            //       value: PriorityLevel.high,
            //       groupValue: selectedPriority,
            //       onChanged: (PriorityLevel? value) {
            //         // Update the state using the provider's notifier
            //         ref.read(radioButtonProvider.notifier).state = value;
            //       },
            //     ),
            //      Text("High",style: GoogleFonts.poppins(
            //        fontSize: 13,
            //        fontWeight: FontWeight.w600
            //      ),),
            //
            //     Radio<PriorityLevel>(
            //       value: PriorityLevel.medium,
            //       groupValue: selectedPriority,
            //       onChanged: (PriorityLevel? value) {
            //         // Update the state using the provider's notifier
            //         ref.read(radioButtonProvider.notifier).state = value;
            //       },
            //     ),
            //      Text("Medium", style: GoogleFonts.poppins(
            //        fontSize: 13,
            //        fontWeight: FontWeight.w600
            //      ),),
            //
            //     Radio<PriorityLevel>(
            //       value: PriorityLevel.low,
            //       groupValue: selectedPriority,
            //       onChanged: (PriorityLevel? value) {
            //         // Update the state using the provider's notifier
            //         ref.read(radioButtonProvider.notifier).state = value;
            //       },
            //     ),
            //     Text("Low",style: GoogleFonts.poppins(
            //       fontSize: 13,
            //       fontWeight: FontWeight.w600,
            //     ),),
            //   ],
            // ),

            // Display the selected option

            SizedBox(height: 16,),



            const SizedBox(height: 16),

            // Media Selection Row
            // Add header text
            Center(
              child: Text(
                "Upload Related Files",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 22,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                _buildMediaButton(Icons.photo_album, "Photo", () => _pickImage(context)),
                _buildMediaButton(Icons.video_call,"Video" , () => _pickVideo(context)),
                _buildMediaButton(Icons.file_copy,"File", () => _pickFile(context)),
              ],
            ),

            SizedBox(height: 16,),
            Center(child: ElevatedButton(

                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade500
                ,minimumSize: Size(250,45)),
                onPressed: (){

                  if(_eventDateTimeController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Date and Time")));
                  }
                  else if(_eventNameController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Event Name")));
                  }
                  else if(_eventLocationController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Event Location")));
                  }
                  else if(_eventDescriptionController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Event Description")));
                  }
                  else if(selectedPriority==null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Priority")));
                  }
                  else {

                    // ✅ Pass Validated Data to AttachWithDB Class (Maintaining Your Structure)
                    AttachWithDB newEvent = AttachWithDB(
                      name: _eventNameController.text.trim(),
                      date: _eventDateTimeController.text.trim(),
                      description: _eventDescriptionController.text.trim(),
                      location: _eventLocationController.text.trim(),
                      category: categoriesvalue.toString(),
                      priority: selectedPriority.toString(),
                      file: file,  // Keep structure (can add file picker)
                      image: image, // Keep structure (can add image)
                      video: video, // Keep structure (can add video)
                      customCategory: categories, // Keep structure (pass category list)
                    );

                            print(
     "${newEvent.name}"+"${newEvent.date}"+
     "${newEvent.description}"+
     "${newEvent.location}"+ "${newEvent.category}"+
     "${newEvent.priority}"+ "${newEvent.file}"+
     "${newEvent.image}"+ "${newEvent.video}"+
     "${newEvent.customCategory}");
      //This is the Sending Data to the Database


     newEvent.connect(context); //call the function which connect the database to our project

                  }
                },
                child: Text("Submit",style: TextStyle(color: Colors.white),)),)
          ],
        ),

      ),
    );
  }








  //This is for the Managing the Image
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ref.read(imageprovider.notifier).state = image;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Selected Successfully")));
    }
  }

  //This is for the Managing the Video
  Future<void> _pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      ref.read(videoControllerProvider.notifier).setVideo(video!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video Selected Successfully")));
    }
  }


  //This is for the Manging the File
  // Function to pick a file
  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
     file = result.files.first;

      // Updating the provider state
      ref.read(fileProvider.notifier).state = file;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File Selected Successfully")));
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
      hintStyle:GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}


//This is for the Managing the Video and image make sure of that
Widget _buildMediaButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    children: [
      IconButton(onPressed: onPressed, icon: Icon(icon, color: Colors.deepOrange)),
      Text(label,style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700
      ),),
    ],
  );
}




