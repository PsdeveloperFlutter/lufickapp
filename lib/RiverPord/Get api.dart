import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'GetApis.dart';

void main() {
  runApp(ProviderScope(child: MyAppss()));
}

// Model class for JSON Data
class Jsondata {
  final int userId;
  final int id;
  final String title;
  final String body;

  Jsondata({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Jsondata.fromJson(Map<String, dynamic> json) => Jsondata(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );
}

// API Provider using Riverpod's FutureProvider
final apiProvider = FutureProvider<List<Jsondata>>((ref) async {
  final response =
  await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Jsondata.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load data");
  }
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Fetch API with Riverpod")),
        body: Consumer(
          builder: (context, ref, child) {
            final asyncData = ref.watch(apiProvider);
            return asyncData.when(
              data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ListTile(
                    title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.body),
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text("Error: $error")),
            );
          },
        ),
        floatingActionButton: Consumer(
          builder: (context, ref, child) {
            return FloatingActionButton(
              onPressed: () {
                ref.invalidate(apiProvider); // Refresh API Data
              },
              child: Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }
}
