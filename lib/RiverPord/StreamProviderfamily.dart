// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Step 1: Create a function that simulates fetching messages for a chat room.
// This function generates a stream of messages dynamically.
Stream<List<String>> fetchMessages(String chatRoomId) async* {
  // Infinite loop to keep generating messages
  while (true) {
    // Simulating a delay for fetching messages (e.g., from a server or database)
    await Future.delayed(const Duration(seconds: 2));

    // Yielding a new list of messages (simulating new data for the chat room)
    yield [
      'Message 1 from $chatRoomId', // Example message 1
      'Message 2 from $chatRoomId', // Example message 2
    ];
  }
}

// Step 2: Create a StreamProvider.family to dynamically handle streams
// based on a given parameter (in this case, the chat room ID).
final chatMessagesProvider = StreamProvider.family<List<String>, String>((ref, chatRoomId) {
  // Return the stream generated for the specific chatRoomId
  return fetchMessages(chatRoomId);
});

// Step 3: Build a ConsumerWidget for the chat screen that listens to the stream.
class ChatScreen extends ConsumerWidget {
  // The chat room ID for which this screen will fetch messages
  final String chatRoomId;

  // Constructor to initialize the chatRoomId
  const ChatScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the StreamProvider with the given chatRoomId
    // It listens to real-time updates and provides the current state of the stream.
    final chatMessagesAsync = ref.watch(chatMessagesProvider(chatRoomId));

    // Building the UI for the chat screen
    return Scaffold(
      // AppBar to display the chat room's title
      appBar: AppBar(
        title: Text('Chat Room $chatRoomId'), // Dynamic chat room title
      ),

      // Body of the chat screen
      body: chatMessagesAsync.when(
        // Data state: When the stream emits new messages, display them in a ListView
        data: (messages) {
          return ListView.builder(
            itemCount: messages.length, // Number of messages in the list
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(messages[index]), // Display each message
              );
            },
          );
        },

        // Loading state: Display a loading indicator while waiting for stream data
        loading: () => const Center(child: CircularProgressIndicator()),

        // Error state: Display an error message if the stream encounters an error
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// Step 4: Entry point of the application
void main() {
  runApp(
    // ProviderScope is required to use Riverpod providers.
    const ProviderScope(
      child: MaterialApp(
        // Disabling the debug banner for a cleaner UI
        debugShowCheckedModeBanner: false,

        // Starting the app with the ChatScreen and passing an initial chatRoomId
        home: ChatScreen(chatRoomId: 'room1'), // You can change this ID dynamically
      ),
    ),
  );
}
