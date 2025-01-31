import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Database/Main_Database_App.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Event_Management_Update.dart';
import 'PDF_generation.dart';

class EventsScreen extends ConsumerStatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  Timer? _searchTimer;
  bool isSorted = false; // Track sorting state
  bool isAscending = true; // Track sorting order

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(eventsProvider);
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  // Helper function for handling null values
  String getValue(String? value, {String defaultValue = 'Not selected'}) {
    return value ?? defaultValue;
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
    });

    if (value.isEmpty) {
      _searchTimer?.cancel();
      _searchTimer = Timer(Duration(milliseconds: 500), () {
        setState(() {});
      });
    }
  }


  // Function to parse and compare dates
  DateTime parseDate(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime(2000, 1, 1); // Default fallback date
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(eventsProvider);

    // Ensure the provider refreshes after the UI builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return ref.refresh(eventsProvider);
    });
    return Scaffold(

      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 60),
        child: FloatingActionButton(
          backgroundColor: Colors.green.shade500,
          onPressed: () {
            setState(() {
              isSorted = true; // Always enable sorting when button is pressed
              isAscending = !isAscending; // Toggle sorting order
              WidgetsBinding.instance.addPostFrameCallback((_) {
               return  ref.refresh(eventsProvider);
              });
            });
          },
          child: Icon(Icons.sort, color: Colors.white),
        ),
      ),

      body: Column(

        children: [

          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(

              controller: searchController,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.aBeeZee(
                ),
                hintStyle: GoogleFonts.aBeeZee(
                ),
                hintText: "Search Events",
                labelText: 'Search Events',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30,),
                  borderSide: BorderSide(color: Colors.black,width: 10)
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: eventsAsyncValue.when(
              data: (events) {


                // Filter events based on search
                List<Map<String, dynamic>> filteredEvents = events
                    .where((event) => event['name'].toLowerCase().contains(searchQuery))
                    .toList();

                // Sort by date if sorting is enabled
                if (isSorted) {
                  filteredEvents.sort((a, b) {
                    DateTime dateA = parseDate(a['date_time']);
                    DateTime dateB = parseDate(b['date_time']);
                    return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
                  });
                }

                if (events.isEmpty) {
                  return Center(child: Text('No events found.'));
                }
                if (filteredEvents.isEmpty) {
                  return Center(child: Text('No events found. Restoring list...'));
                }

                return ListView.builder(
                    itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      front: Container(
                        height: 400,
                        margin: EdgeInsets.all(8),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Details
                                  Text(
                                    'Event :-  ${getValue(event['name'])}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Date & Time: ${formatDate(event['date_time'])}', style: GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Category: ${getValue(event['category'])}', style:GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Location: ${getValue(event['location'])}', style: GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Description: ${getValue(event ['description'])}', style:GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Priority: ${formatPriority(event['priority'])}', style: GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Custom Category : ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}', style:GoogleFonts.aboreto(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                              
                                  // Actions (Edit, Delete, Share, PDF)
                                  SizedBox(height: 12),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UpdateEventUI(
                                                  index: index,
                                                  eventName: event['name'],
                                                  eventDateTime: event['date_time'],
                                                  eventLocation: event['location'],
                                                  eventDescription: event['description'],
                                                  eventPriority: event['priority'],
                                                    imagepath: event['image_path'],
                                                  filepath:event['file_path'],
                                                  id:event['id'],
                                                  videopath: event['video_path'],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.edit, color: Colors.green.shade700),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Confirm Delete", style: TextStyle(color: Colors.red.shade700)),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Cancel', style: TextStyle(color: Colors.green.shade700)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await DatabaseHelper.instance.deleteEvent(event['id']).then(
                                                                (value) => ref.refresh(eventsProvider),
                                                          );
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Delete', style: TextStyle(color: Colors.red.shade700)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.delete, color: Colors.red.shade700),
                                        ),


                                                      IconButton(
                                                          onPressed: () async {
                                                    final eventDetails = '''
                                    Event: ${getValue(event['name'])}
                                    Date & Time: ${getValue(event['date_time'])}
                                    Category: ${getValue(event['category'])}
                                    Location: ${getValue(event['location'])}
                                    Description: ${getValue(event['description'])}
                                    Priority: ${getValue(event['priority'])}
                                    Custom Category: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}
                                    ''';

                                                    // Initialize a list for media paths (XFile)
                                                    List<XFile> mediaPaths = [];

                                                    // Check if there's an image and copy it to a shareable directory
                                                    if (event['image_path'] != null && event['image_path'] != '') {
                                                    try {
                                                    XFile imageFile = await _copyImageToTempDirectory(event['image_path']);
                                                    mediaPaths.add(imageFile);
                                                    } catch (e) {
                                                    print("Error copying image: $e");
                                                    }
                                                    }

                                                    // Check if there's a video and add it to the mediaPaths
                                                    if (event['video_path'] != null && event['video_path'] != '') {
                                                    mediaPaths.add(XFile(event['video_path']));
                                                    }

                                                    // Check if there's a file and add it to the mediaPaths
                                                    if (event['file_path'] != null && event['file_path'] != '') {
                                                    mediaPaths.add(XFile(event['file_path']));
                                                    }

                                                    // Combine event details and media paths to share
                                                    String shareText = eventDetails;
                                                    if (mediaPaths.isNotEmpty) {
                                                    shareText += '\n\nMedia Files:\n${mediaPaths.map((e) => e.path).join("\n")}';
                                                    }

                                                    // Share media files along with event details
                                                    if (mediaPaths.isNotEmpty) {
                                                    Share.shareXFiles(mediaPaths, text: shareText);
                                                    } else {
                                                    // Share only the event details if there are no media files
                                                    Share.share(shareText);
                                                    }
                                                    },
                                                      icon: Icon(Icons.share, color: Colors.blue.shade700),
                                                    ),


                                        IconButton(
                                          onPressed: () async {
                                            await PdfGenerator.generatePdf(event,event['name']);
                                          },
                                          icon: Icon(Icons.picture_as_pdf, color: Colors.green.shade700),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            try{
                                              await PdfGenerator.generatePdf(event,event['name']).then((value) =>SnackBar(content: Text("PDF Downloaded Successfully")));
                                            }catch(e){
                                              SnackBar(content: Text("PDF Downloaded Successfully"));
                                            }
                                            finally{
                                              print("Code Here Successfully Executed");
                                            }
                                          },
                                          icon: Icon(Icons.download, color: Colors.blue.shade700),
                                        ),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.notification_add, color: Colors.blue.shade700),),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      back: Container(
                        height: 400,
                        margin: EdgeInsets.all(8),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 5),
                                  event['image_path'] != null
                                      ? Column(
                                    children: [
                         Center(child:
                     Text("Image Section",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 16),)),
                     SizedBox(height: 12,),
                     ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                       child: Image.file(File(event['image_path']),fit: BoxFit.cover,width: 200,height: 200,
                       ),
                     )],
                                  )
                                      : Text("No Image", style: TextStyle(color: Colors.red.shade700)),


                                  SizedBox(height: 18,),



                                  //This is for showing the file on the back side from database

                                  event['file_path']!=null
                                  ?
                                      Column(
                                        children:[
                                          Center(
                                            child:Text("File Section",style:GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 16))
                                          ),
                                          SizedBox(height: 12,),
                                          ElevatedButton.icon(onPressed: (){

                                            //When the Button Press so At that case it will show the Option for the Opening with the
                                            //File by many options
                                            File file = File(event['file_path']);
                                            if (file.existsSync()) {
                                              OpenFile.open(file.path); // Requires `open_file` package
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("File not found")),
                                              );
                                            }
                                          },

                                              icon: Icon(Icons.insert_drive_file,color: Colors.purple,),
                                              label: Text("Open File",style: GoogleFonts.aBeeZee(fontSize: 16),)
                                          )
                                        ]
                                      ):Text("No File",style:TextStyle(color:Colors.red.shade700)),
                                  //This is for the Operation Purpose for the Events make sure of this
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateEventUI(
                                                index: index,
                                                eventName: event['name'],
                                                eventDateTime: event['date_time'],
                                                eventLocation: event['location'],
                                                eventDescription: event['description'],
                                                eventPriority: event['priority'],
                                                imagepath: event['image_path'],
                                                filepath:event['file_path'],
                                                id: event['id'],
                                                videopath: event['video_path'],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit, color: Colors.green.shade700),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Confirm Delete", style: TextStyle(color: Colors.red.shade700)),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel', style: TextStyle(color: Colors.green.shade700)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await DatabaseHelper.instance.deleteEvent(event['id']).then(
                                                              (value) => ref.refresh(eventsProvider),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Delete', style: TextStyle(color: Colors.red.shade700)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red.shade700),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final eventDetails = '''
    DateTime? eventDate=getValue(event['date_time']);
    String fromattedTime=DateFormat('dd-MM-yyyy').format(eventDate!);
    Event: ${getValue(event['name'])}
    Date & Time: fromattedTime
    Category: ${getValue(event['category'])}
    Location: ${getValue(event['location'])}
    Description: ${getValue(event['description'])}
    Priority: ${getValue(event['priority'])}
    Custom Category: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}
    ''';

                                          // Initialize a list for media paths (XFile)
                                          List<XFile> mediaPaths = [];

                                          // Check if there's an image and copy it to a shareable directory
                                          if (event['image_path'] != null && event['image_path'] != '') {
                                            try {
                                              XFile imageFile = await _copyImageToTempDirectory(event['image_path']);
                                              mediaPaths.add(imageFile);
                                            } catch (e) {
                                              print("Error copying image: $e");
                                            }
                                          }

                                          // Check if there's a video and add it to the mediaPaths
                                          if (event['video_path'] != null && event['video_path'] != '') {
                                            mediaPaths.add(XFile(event['video_path']));
                                          }

                                          // Check if there's a file and add it to the mediaPaths
                                          if (event['file_path'] != null && event['file_path'] != '') {
                                            mediaPaths.add(XFile(event['file_path']));
                                          }

                                          // Combine event details and media paths to share
                                          String shareText = eventDetails;
                                          if (mediaPaths.isNotEmpty) {
                                            shareText += '\n\nMedia Files:\n${mediaPaths.map((e) => e.path).join("\n")}';
                                          }

                                          // Share media files along with event details
                                          if (mediaPaths.isNotEmpty) {
                                            Share.shareXFiles(mediaPaths, text: shareText);
                                          } else {
                                            // Share only the event details if there are no media files
                                            Share.share(shareText);
                                          }
                                        },
                                        icon: Icon(Icons.share, color: Colors.blue.shade700),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error fetching events: $error')),
            ),
          ),
        ],
      ),
    );
  }

 dynamic formatPriority(String? event) {
  String? priority = event; // Extract priority string

  if(priority?.toLowerCase() == "high"){
      return "High";
    }
    else if(priority?.toLowerCase() == "low"){
      return "Low";
    }
    else if(priority?.toLowerCase() == "medium"){
      return "Medium";
    }
    else {
      return "Not set";
    }
 }

  // Helper function to copy the image to a temporary directory
  //n to copy the image to a temporary directory
  Future<XFile> _copyImageToTempDirectory(String imagePath) async {
    final directory = await getTemporaryDirectory();
    final tempFile = File('${directory.path}/shared_image.jpg');
    final imageFile = File(imagePath);
    await imageFile.copy(tempFile.path); // Copy image to temp directory
    return XFile(tempFile.path);
  }

  formatDate(event) {
    if(event==null){
      return 'Not set'; // Handle null case
    }
    try{
      DateTime? eventtime=DateTime.parse(event);
      return DateFormat("dd-MM-yyyy").format(eventtime);
    }
    catch(e){
      return 'Invalid date'; // In case the parsing fails
    }
  }
}
/*
Here’s the logic behind the code, broken down step-by-step:

### 1. **Get Event Details**:
   - First, you collect the event details (name, date, location, etc.) from your database.
   - These details are stored in the `eventDetails` string, which will be shared.

### 2. **Initialize Media Paths List**:
   - You initialize an empty list `mediaPaths` to hold the media files (images, videos, files) that you want to share.
   - This list will be populated with the `XFile` objects, which are used by the `Share.shareXFiles` method.

### 3. **Check and Handle Image**:
   - If there’s an image path in the database (i.e., `event['image_path']` is not null or empty), you:
     1. Use the helper function `_copyImageToTempDirectory` to copy the image file to a temporary directory.
     2. Add the copied image file (`XFile`) to the `mediaPaths` list.
   - This is done to ensure that the image is shareable (instead of just the path).

### 4. **Check and Handle Video**:
   - If there’s a video path in the database (i.e., `event['video_path']` is not null or empty), you:
     1. Add the video file path as an `XFile` to the `mediaPaths` list.
   - This ensures that the video file is included in the sharing operation.

### 5. **Check and Handle File**:
   - If there’s a file path in the database (i.e., `event['file_path']` is not null or empty), you:
     1. Add the file path as an `XFile` to the `mediaPaths` list.
   - This ensures that any additional files (like PDFs, docs, etc.) are shared as well.

### 6. **Combine Event Details with Media**:
   - Once all media paths (image, video, file) are added to `mediaPaths`, you combine the `eventDetails` with the list of media paths.
   - The media paths are appended to the `shareText` string, formatted in a readable way.
   - If `mediaPaths` is empty, you only share the event details without media.

### 7. **Share Event Details**:
   - If there are media files in `mediaPaths`, you use `Share.shareXFiles` to share the event details along with the media files.
   - If there are no media files, you use `Share.share` to share just the event details (without any files).

### 8. **Helper Function to Copy Image**:
   - The `_copyImageToTempDirectory` function is responsible for:
     1. Copying the image from the provided path to a temporary directory.
     2. Returning the `XFile` representing the image in the temporary directory.

### Summary of the Process:
1. Get the event details from the database.
2. Initialize a list to hold the media files (images, videos, and files).
3. Check for each type of media (image, video, file) and copy them to the `mediaPaths` list (with images being copied to a temporary directory for shareability).
4. Combine the event details and media paths into a single text string.
5. Share the combined event details and media files using `Share.shareXFiles` (or just event details if no media files are available).
6. Use a helper function to ensure images are copied to a shareable directory.

This flow ensures that when the user clicks the share button, they are able to share both the event details and the associated media (image, video, file), with all necessary files being properly prepared for sharing.
*/