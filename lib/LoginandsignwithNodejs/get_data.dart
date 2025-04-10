import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.29.65:3000'; // Match with main.dart

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  List<dynamic> dataList = [];
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final response = await http.get(Uri.parse('$baseUrl/read-data'));

    if (response.statusCode == 200) {
      setState(() {
        dataList = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Data')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dataList.isEmpty
          ? Center(child: Text('No Data Found'))
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return ListTile(
            title: Text(item['name'] ?? ''),
            subtitle: Text('Age: ${item['age'] ?? ''}'),
          );
        },
      ),
    );
  }
}
