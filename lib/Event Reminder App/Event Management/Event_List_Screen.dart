import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Database/Main_Database_App.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart';
import 'Event_Management_Update.dart';
class EventsScreen extends ConsumerStatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(eventsProvider); // Refresh the provider to ensure up-to-date data
    });
  }

  // Helper function to handle null values and provide a default message
  String getValue(String? value, {String defaultValue = 'Not selected'}) {
    return value ?? defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(eventsProvider);

    return Scaffold(
      body: eventsAsyncValue.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Container(
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
                        // Event Name
                        Text(
                          'Event Name: ${getValue(event['name'])}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),

                        // Event Date & Time
                        Text(
                          'Date & Time: ${getValue(event['date_time'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Event Category
                        Text(
                          'Category: ${getValue(event['category'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Event Location
                        Text(
                          'Location: ${getValue(event['location'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Event Description
                        Text(
                          'Description: ${getValue(event['description'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Event Priority
                        Text(
                          'Priority: ${getValue(event['priority'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Reminder Time (if available)
                        Text(
                          'Reminder Time: ${getValue(event['reminder_time'], defaultValue: 'Not set')}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Repeat Option (if available)
                        Text(
                          'Repeat Option: ${getValue(event['repeat_option'], defaultValue: 'Not set')}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),

                        // Custom Interval (if available)
                        Text(
                          'Custom Interval: ${getValue(event['custom_interval']?.toString(), defaultValue: 'Not set')}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),

                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Navigate to UpdateEventUI with event data and index
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateEventUI(
                                      index: index,  // Pass the index
                                      eventName: event[index]['name'],
                                      eventDateTime: event['date_time'],
                                      eventLocation: event['location'],
                                      eventDescription: event['description'],
                                      eventPriority: event[index]['priority'],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                             IconButton(onPressed: () async{
                               await DatabaseHelper.instance.deleteEvent(event['id']).
                                   then((value) =>
                                   ref.refresh(eventsProvider)    // Refresh the provider
                               );
                             }, icon: Icon(Icons.delete))
                          ],
                        ),
                      ],
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
    );
  }
}
