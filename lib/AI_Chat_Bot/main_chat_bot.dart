import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const String geminiKey = "AIzaSyALT4eqW0pHeFduDIMsVg7uJYiq1fXheSo";

void main() {
  Gemini.init(apiKey: geminiKey, enableDebugging: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatBot(),
    );
  }
}

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(id: "1", firstName: "User");
  ChatUser geminibotUser = ChatUser(id: "2", firstName: "Bot");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: messages,
    );
  }

  void sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;

      gemini.streamGenerateContent(question).listen((event) {
        // Extract the response text

        String response = event.content?.parts
            ?.map((part) => (part as Map<String, dynamic>)['text'] ?? "")
            .join(" ") ?? "No response from Gemini.";


        // Check if the last message is from the bot
        ChatMessage? lastMessage =
        messages.isNotEmpty && messages.first.user == geminibotUser
            ? messages.first
            : null;

        if (lastMessage != null) {
          // Append to the existing bot message
          setState(() {
            messages = [
              ChatMessage(
                text: lastMessage.text + response,
                user: geminibotUser,
                createdAt: DateTime.now(),
              ),
              ...messages.skip(1),
            ];
          });
        } else {
          // Create a new bot message
          ChatMessage botMessage = ChatMessage(
            user: geminibotUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [botMessage, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        messages = [
          ChatMessage(
            user: geminibotUser,
            createdAt: DateTime.now(),
            text: "Sorry, an error occurred: $e",
          ),
          ...messages,
        ];
      });
    }
  }
}
