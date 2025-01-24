import 'dart:async';
import 'dart:io';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lufickapp/Todo_Application/screen/Videoplayer.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../Database/Main_Database_App.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Event_Management_Update.dart';

class EventsScreen extends ConsumerStatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  Timer? _searchTimer;
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
  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(eventsProvider);

    return Scaffold(
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Events',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: eventsAsyncValue.when(
              data: (events) {
                final filteredEvents=events.where((event)=>event['name'].toLowerCase().contains(searchQuery));

                if (events.isEmpty) {
                  return Center(child: Text('No events found.'));
                }
                if (filteredEvents.isEmpty) {
                  return Center(child: Text('No events found. Restoring list...'));
                }

                return ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = events[index];



                    return FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      front: Container(
                        height: 500,
                        margin: EdgeInsets.all(8),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Event Details
                                Text(
                                  'Event :-  ${getValue(event['name'])}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Text('Date & Time: ${getValue(event['date_time'])}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Category: ${getValue(event['category'])}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Location: ${getValue(event['location'])}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Description: ${getValue(event['description'])}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Priority: ${getValue(event['priority'])}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Reminder Time: ${getValue(event['reminder_time'], defaultValue: 'Not set')}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Repeat Option: ${getValue(event['repeat_option'], defaultValue: 'Not set')}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('Custom Interval: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),

                                // Actions (Edit, Delete, Share, PDF)
                                SizedBox(height: 12),
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
                                      onPressed: () {
                                        final eventDetails = '''
                              Event: ${getValue(event['name'])}
                              Date & Time: ${getValue(event['date_time'])}
                              Category: ${getValue(event['category'])}
                              Location: ${getValue(event['location'])}
                              Description: ${getValue(event['description'])}
                              Priority: ${getValue(event['priority'])}
                              Reminder Time: ${getValue(event['reminder_time'], defaultValue: 'Not set')}
                              Repeat Option: ${getValue(event['repeat_option'], defaultValue: 'Not set')}
                              Custom Interval: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}
                              ''';

                                        Share.share(eventDetails);
                                      },
                                      icon: Icon(Icons.share, color: Colors.blue.shade700),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.picture_as_pdf, color: Colors.green.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      back: Container(
                        height: 500,
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
                     Text("Image Section",style: TextStyle(fontWeight: FontWeight.bold),)), Image.file(File(event['image_path']),fit: BoxFit.cover,width: 200,height: 200,)],
                                  )
                                      : Text("No Image", style: TextStyle(color: Colors.red.shade700)),


                                  SizedBox(height: 18,),



                                  //This is for showing the file on the back side from database

                                  event['file_path']!=null
                                  ?
                                      Column(
                                        children:[
                                          Center(
                                            child:Text("File Section",style:TextStyle(fontWeight:FontWeight.bold))
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

                                              icon: Icon(Icons.insert_drive_file),
                                              label: Text("Open File")
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
                                        onPressed: () {
                                          final eventDetails = '''
                              Event: ${getValue(event['name'])}
                              Date & Time: ${getValue(event['date_time'])}
                              Category: ${getValue(event['category'])}
                              Location: ${getValue(event['location'])}
                              Description: ${getValue(event['description'])}
                              Priority: ${getValue(event['priority'])}
                              Reminder Time: ${getValue(event['reminder_time'], defaultValue: 'Not set')}
                              Repeat Option: ${getValue(event['repeat_option'], defaultValue: 'Not set')}
                              Custom Interval: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}
                              ''';

                                          Share.share(eventDetails);
                                        },
                                        icon: Icon(Icons.share, color: Colors.blue.shade700),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.picture_as_pdf, color: Colors.green.shade700),
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
}
