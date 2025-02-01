import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventProvider=Provider.family<String,int>((ref,event){
  return "Event $event";
});

class EventScreen extends ConsumerWidget {
  final int eventId;

  EventScreen(this.eventId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: Center(child: Text(event)),
    );
  }
}

void main(){

  runApp(ProviderScope(child: MaterialApp(
    home: EventScreen(1),
  )));
}