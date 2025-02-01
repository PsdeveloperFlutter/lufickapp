import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:lufickapp/Event%20Reminder%20App/Controller%20of%20App/Controller1.dart';
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
        floatingActionButton: FloatingActionButton(onPressed: (){
          final ThemeController themeController = Get.find();
          themeController.toggletheme();
        },child: Icon(Icons.toggle_off,color: Colors.white,),backgroundColor: Colors.green,),


        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.event,color: Colors.green),),
              Tab(icon: Icon(Icons.create,color: Colors.green,)),
            ],
          ),
          title:Text(
            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
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
  _EventCreationUIState createState() => _EventCreationUIState();
}

class _EventCreationUIState extends ConsumerState<EventCreationUI> {
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

            //Expansion Title Widget for Managing the Category of the Event

            ExpansionTile(title: Text("Category",style:GoogleFonts.poppins(fontStyle: FontStyle.italic,fontSize: 20,fontWeight: FontWeight.w500),),
                children: [
                  Container(
                    width: 300,
                    height: 180,
                    child: ListView.builder(itemBuilder: (context,index){
                      return
                        GestureDetector(
                          onTap: (){

                            setState(() {
                              categoriesvalue=categories[index];
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You Select ${categories[index]} Category")));
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
            }, child: Text("Set Notification",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800
                ),)),


            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.only(left:26.0),
              child: Text("Priority",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.bold),),
            )
            // Radio Button
            ,
            SizedBox(height: 7,),
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
                 Text("High",style: GoogleFonts.poppins(
                   fontSize: 13,
                   fontWeight: FontWeight.w600
                 ),),

                Radio<PriorityLevel>(
                  value: PriorityLevel.medium,
                  groupValue: selectedPriority,
                  onChanged: (PriorityLevel? value) {
                    // Update the state using the provider's notifier
                    ref.read(radioButtonProvider.notifier).state = value;
                  },
                ),
                 Text("Medium", style: GoogleFonts.poppins(
                   fontSize: 13,
                   fontWeight: FontWeight.w600
                 ),),

                Radio<PriorityLevel>(
                  value: PriorityLevel.low,
                  groupValue: selectedPriority,
                  onChanged: (PriorityLevel? value) {
                    // Update the state using the provider's notifier
                    ref.read(radioButtonProvider.notifier).state = value;
                  },
                ),
                Text("Low",style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),),
              ],
            ),

            // Display the selected option

            SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Selected Priority: ${selectedPriority?.name??"Not Selected"}",style: GoogleFonts.poppins
                (fontSize: 13,fontWeight: FontWeight.bold),),
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

            SizedBox(height: 12,),
            Center(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
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


     newEvent.connect(); //call the function which connect the database to our project

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




