import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class User {
  final String name;
  final String age;
  final String phone;
  final String email;
  final String? imagepath;
  final String? filepath;

  User(
      {required this.name,
      required this.age,
      required this.phone,
      required this.email,
      this.imagepath,
      this.filepath});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      phone: json['phone'],
      email: json['email'],
      imagepath: json['imagePath'],
      filepath: json['filePath'],
    );
  }
}

class FetchDataScreen extends StatefulWidget {
  @override
  State<FetchDataScreen> createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.29.65:3000/readdata'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        users = data.map((userjson) => User.fromJson(userjson)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to fetch data"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fetch Data"),
        ),
        body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Card(
                  child: ListTile(
                    title: Text(users[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Age: ${users[index].age}"),
                        Text("Phone: ${users[index].phone}"),
                        Text("Email: ${users[index].email}"),
                        // Only show image if imagepath is not null
                        users[index].imagepath == null
                            ? Text("Image Not Selected")
                            : Image.network(
                                "http://192.168.29.65:3000/${users[index].imagepath.toString()}",
                              ),
                        users[index].filepath == null
                            ? Text("File Not Selected")
                            : InkWell(
                                onTap: () async {
                                  final url =
                                      "http://192.168.29.65:3000/${users[index].filepath}";
                                  final response =
                                      await http.get(Uri.parse(url));

                                  if (response.statusCode == 200) {
                                    final bytes = response.bodyBytes;
                                    final dir = await getTemporaryDirectory();
                                    final file = File('${dir.path}/temp.pdf');
                                    await file.writeAsBytes(bytes);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return pdfViewScreen(
                                            pdfview: file.path);
                                      }),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Failed to download PDF")),
                                    );
                                  }
                                },
                                child: Text(
                                  "View PDF",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

class pdfViewScreen extends StatelessWidget {
  final String pdfview;

  const pdfViewScreen({super.key, required this.pdfview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: pdfview,
      ),
    );
  }
}
