import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lufickapp/Event%20Reminder%20App/Controller%20of%20App/Controller1.dart';
import 'package:lufickapp/Event%20Reminder%20App/Database/Main_Database_App.dart';
import 'package:lufickapp/Event%20Reminder%20App/Event%20Management/Get%20X%20Storage.dart';
import 'package:lufickapp/Event%20Reminder%20App/NotificationCode/UI_Notification/SecondUIofNotifications.dart';
import '../Getx Storage/Them e Change getxController.dart';
import '../Loginandsignsection/Firebase Functionality/Login and Signin Functionality .dart';
import '../Loginandsignsection/Login And Sign up.dart';
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

      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'App Lock') {
            // Handle App Lock logic here
          } else if (value == 'Backup Data') {
            // Handle Backup Data logic here

          }
          else if(value =="Logout"){



          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Set Pin',
            child: Text('Set Pin'),
          ),
          PopupMenuItem<String>(
            value: 'Backup Data',
            child: const Text('Backup Data'),
            onTap: (){
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

            },
          ),



          PopupMenuItem<String>(
            value: 'Logout',
            child: const Text('Logout'),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer(builder: (context,ref,child){
                    return
                      AlertDialog(
                        title: const Text('Confirm Logout'), // Your title here
                        content: const Text('Are you sure you want to logout.'), // Your content here
                        actions: <Widget>[ // Buttons at the bottom
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async{
                              LoggingService.logout();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                  });
                },
              );

            },
          ),
        ],
      ),
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


  //This is for the Notification Purpose make sure of that
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();





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


            Text(
              "Schedule Date and Time",
              style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            SizedBox(height:15),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Date',
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
                hintText: 'Tap to choose a date',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                    selectedDate = pickedDate;
                  });
                }
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Time',
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
                hintText: 'Tap to choose a time',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.access_time,
                  color: Colors.blue,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),

            SizedBox(height:22),








            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Priority", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),

                SizedBox(width: 18),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white60)
                  ),
                  width:300,
                  child: Center(
                    child: DropdownButton<PriorityLevel>(
                      isExpanded: true,
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
                            });
                          ref.read(radioButtonProvider.notifier).state = newValue;
                        }
                      },
                    ),
                  ),
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
            Text(
              "Upload Related Files",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            GestureDetector(
               onTap: (){

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

                   //First notification set up and after that Database set with data
                   _scheduleNotification();

                   // Parse the custom date string properly
                   DateTime parsedDate = DateFormat("dd-MM-yyyy hh:mm a").parse(_eventDateTimeController.text.trim());

                   // ✅ Pass Validated Data to AttachWithDB Class (Maintaining Your Structure)
                   AttachWithDB newEvent = AttachWithDB(
                     name: _eventNameController.text.trim(),
                     date:parsedDate.toString(),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(5)
                ),
                width: 300,
                height: 48,
                child:Center(child: Text("Submit",style: TextStyle(color:Colors.white,fontSize: 15),))
              ),
            )
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



    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
     file = result.files.first;

      // Updating the provider state
      ref.read(fileProvider.notifier).state = file;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File Selected Successfully")));
    }
  }


  void _scheduleNotification() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    if (_eventNameController.text.isEmpty||
        _eventLocationController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all event details')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final formattedDate =
    DateFormat('dd-MM-yyyy – kk:mm').format(scheduledDateTime);

    // Call the Schedule Notification Function
    scheduleNotification(
      scheduledDateTime,
      'Notification at $formattedDate',
     _eventNameController.text.toString(),
     _eventLocationController.text.toString(),
      _eventDescriptionController.text.toString(),
     categoriesvalue.toString(),
    );

    // Show the result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for $formattedDate')),
    );
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
        borderRadius: BorderRadius.circular(5.0),
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





