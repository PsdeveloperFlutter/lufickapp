import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Database/Main_Database_App.dart';
import '../NotificationCode/UI_Notification/SecondUIofNotifications.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Event_Management_Update.dart';
import 'Get X Storage.dart';

class EventsScreen extends ConsumerStatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  // Selected date for the Flutter TimeLine
  DateTime focusedDay = DateTime.now(); // Declare this in your state
  DateTime? selectedDatetl;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  Timer? _searchTimer;
  bool isSorted = false; // Track sorting state
  bool isAscending = true; // Track sorting order
  List<Map<String, dynamic>> filteredEvents = [];

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Ensures the UI adjusts when the keyboard appears
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 48,
              child: TextField(
                minLines: 1,
                controller: searchController,
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.aBeeZee(),
                  hintStyle: GoogleFonts.aBeeZee(),
                  hintText: "Search Events",
                  labelText: 'Search Events',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(color: Colors.black, width: 10)),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          ExpansionTile(
            title: Text("Calendar"),
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                setState(() {
                  selectedDatetl =
                      DateTime(DateTime.now().year, DateTime.now().month, 1);
                });
              }
            },
            children: [
              SingleChildScrollView(
                child: Container(
                    height: 411,
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
                    child: TableCalendar(
                      firstDay: DateTime(2025, 01, 01),
                      lastDay: DateTime(2030, 12, 31),
                      focusedDay: focusedDay,
                      // Ensure this variable exists
                      calendarFormat: CalendarFormat.month,
                      pageAnimationEnabled: true,
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDatetl, day),
                      onPageChanged: (newFocusedDay) {
                        setState(() {
                          focusedDay = newFocusedDay; // Update focused month
                        });
                      },
                      onDaySelected: (selectedDay, newFocusedDay) {
                        setState(() {
                          selectedDatetl = selectedDay;
                          focusedDay =
                              newFocusedDay; // Ensure month changes when selecting a date
                        });
                      },
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: eventsAsyncValue.when(
              data: (events) {
                // Filter events based on search
                filteredEvents = events
                    .where((event) =>
                        event['name'].toLowerCase().contains(searchQuery))
                    .toList();

                // Sort by date if sorting is enabled
                if (isSorted) {
                  filteredEvents.sort((a, b) {
                    DateTime dateA = parseDate(a['date_time']);
                    DateTime dateB = parseDate(b['date_time']);
                    return isAscending
                        ? dateA.compareTo(dateB)
                        : dateB.compareTo(dateA);
                  });
                }

                if (events.isEmpty) {
                  return Center(child: Text('No events found.'));
                }
                if (filteredEvents.isEmpty) {
                  return Center(
                      child: Text('No events found. Restoring list...'));
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Date & Time: ${formatDate(event['date_time'])}',
                                      style: GoogleFonts.aboreto(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Location: ${getValue(event['location'])}',
                                      style: GoogleFonts.aboreto(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Description: ${getValue(event['description'])}',
                                      style: GoogleFonts.aboreto(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Priority: ${formatPriority(event['priority'])}',
                                      style: GoogleFonts.aboreto(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Custom Category : ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}',
                                      style: GoogleFonts.aboreto(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold)),

                                  // Actions (Edit, Delete, Share, PDF)
                                  SizedBox(height: 12),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            navigateToUpdateScreen(
                                                context, event);
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.green.shade700),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            deleteconfirmation(context, event);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red.shade700),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            ShareEvent(event);
                                          },
                                          icon: Icon(Icons.share,
                                              color: Colors.blue.shade700),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotificationScreen(
                                                          name: event['name'],
                                                          location:
                                                              event['location'],
                                                          description: event[
                                                              'description'],
                                                          category:
                                                              event['category'],
                                                          priority: event[
                                                              'priority'])),
                                            );
                                          },
                                          icon: Icon(Icons.notification_add,
                                              color: Colors.blue.shade700),
                                        ),

                                        //Here We Recover the data from the GetXStorage make sure of this
                                        IconButton(
                                            onPressed: () {
                                              Map<String, dynamic> data = {
                                                'name': event['name'],
                                                'date_time': event['date_time'],
                                                'category': event['category'],
                                                'location': event['location'],
                                                'description':
                                                    event['description'],
                                                'priority': event['priority'],
                                                'video_path':
                                                    event['video_path'],
                                                'image_path':
                                                    event['image_path'],
                                                'file_path': event['file_path']
                                              };
                                              saveEvent(data, context);

                                              print(getSavedEvents());
                                            },
                                            icon: Icon(Icons.save_alt,
                                                color: Colors.red.shade500))
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  // Image Section
                                  if (event['image_path'] != null)
                                    _buildSection(
                                      title: "Image Section",
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(event['image_path']),
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: 200,
                                        ),
                                      ),
                                    )
                                  else
                                    Text("No Image",
                                        style: TextStyle(
                                            color: Colors.red.shade700)),

                                  // File Section
                                  if (event['file_path'] != null)
                                    _buildSection(
                                      title: "File Section",
                                      child: ElevatedButton.icon(
                                        onPressed: () => _openFile(
                                            context, event['file_path']),
                                        icon: const Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.purple),
                                        label: Text("Open File",
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: 16)),
                                      ),
                                    )
                                  else
                                    Text("No File",
                                        style: TextStyle(
                                            color: Colors.red.shade700)),
                                  const SizedBox(height: 10),
                                  // Video Section
                                  if (event['video_path'] != null)
                                    _buildSection(
                                      title: "Video Section",
                                      child: ElevatedButton.icon(
                                        onPressed: () => _openFile(
                                            context, event['video_path']),
                                        icon: const Icon(Icons.videocam,
                                            color: Colors.purple),
                                        label: Text("Play Video",
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: 16)),
                                      ),
                                    )
                                  else
                                    Text("No Video",
                                        style: TextStyle(
                                            color: Colors.red.shade700)),

                                  //This is for the Operation Purpose for the Events make sure of this
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          navigateToUpdateScreen(
                                              context, event);
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.green.shade700),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteconfirmation(
                                              context, event);
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Colors.red.shade700),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          ShareEvent(event);
                                        },
                                        icon: Icon(Icons.share,
                                            color: Colors.blue.shade700),
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
              error: (error, stackTrace) =>
                  Center(child: Text('Error fetching events: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade500,
        onPressed: () {
          setState(() {
            isSorted = true; // Always enable sorting when button is pressed
            isAscending = !isAscending; // Toggle sorting order
            WidgetsBinding.instance.addPostFrameCallback((_) {
              return ref.refresh(eventsProvider);
            });
          });
        },
        child: Icon(Icons.sort, color: Colors.white),
      ),
    );
  }

  dynamic formatPriority(String? event) {
    String? priority = event; // Extract priority string

    if (priority?.toLowerCase() == "high") {
      return "High";
    } else if (priority?.toLowerCase() == "low") {
      return "Low";
    } else if (priority?.toLowerCase() == "medium") {
      return "Medium";
    } else {
      return "Not set";
    }
  }

  formatDate(event) {
    if (event == null) {
      return 'Not set'; // Handle null case
    }
    try {
      DateTime? eventtime = DateTime.parse(event);
      return DateFormat("dd-MM-yyyy").format(eventtime);
    } catch (e) {
      return 'Invalid date'; // In case the parsing fails
    }
  }

  //This function for the share functionality
  void ShareEvent(Map<String, dynamic> event) async {
    final eventDetails = '''
        Event: ${getValue(event['name'])}
      Date & Time: ${getValue(event['date_time'])}
       Category: ${getValue(event['category'])}
         Location: ${getValue(event['location'])}
        Description: ${getValue(event['description'])}
        Priority: ${getValue(event['priority'])}
       Custom Category: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}''';
    final tempDir = await getTemporaryDirectory();
    final zipFolder = Directory('${tempDir.path}/share_data');
    if (await zipFolder.exists()) {
      await zipFolder.delete(recursive: true);
    }
    await zipFolder.create(recursive: true);

    // Step 1: Write event details to a text file
    final detailsFile = File('${zipFolder.path}/event_details.txt');
    await detailsFile.writeAsString(eventDetails);

    // Step 2: Copy media files
    List<File> mediaFiles = [];
    if (event['image_path'] != null && event['image_path'] != '') {
      mediaFiles.add(File(event['image_path']));
    }
    if (event['video_path'] != null && event['video_path'] != '') {
      mediaFiles.add(File(event['video_path']));
    }
    if (event['file_path'] != null && event['file_path'] != '') {
      mediaFiles.add(File(event['file_path']));
    }

    for (File media in mediaFiles) {
      final fileName = media.path.split('/').last;
      await media.copy('${zipFolder.path}/$fileName');
    }

    // Step 3: Create ZIP from the folder
    final zipPath = '${tempDir.path}/Mainevent_details.zip';
    final zipFile = File(zipPath);
    if (await zipFile.exists()) await zipFile.delete();
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addDirectory(zipFolder);
    encoder.close();

    // Step 4: 	Share the zip file
    await Share.shareXFiles([XFile(zipPath)],
        text: "Event Backup with Media 🎉");
  }

  //This is the function for the Navigation to update section of project
  void navigateToUpdateScreen(
      BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEventUI(
          index: event['id'],
          eventName: event['name'],
          eventDateTime: event['date_time'],
          eventLocation: event['location'],
          eventDescription: event['description'],
          eventPriority: event['priority'],
          imagepath: event['image_path'],
          filepath: event['file_path'],
          id: event['id'],
          videopath: event['video_path'],
        ),
      ),
    );
  }
  //This is the function for the dialogbox of delete
  Future<void> deleteconfirmation(
    BuildContext context,
    Map<String, dynamic> event,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete",
            style: TextStyle(color: Colors.red.shade700)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(color: Colors.green.shade700)),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteEvent(event['id']).then(
                        (value) => ref.refresh(eventsProvider),
                      );
                  Navigator.pop(context);
                },
                child: Text('Delete',
                    style: TextStyle(color: Colors.red.shade700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //This is the function for the image ,video,file
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
  //This is the function for the open file
  void _openFile(BuildContext context, String path) {
    final file = File(path);
    if (file.existsSync()) {
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File not found")),
      );
    }
  }
}
