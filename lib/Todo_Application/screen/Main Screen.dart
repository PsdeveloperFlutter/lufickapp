import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screen of Operation_update.dart';

TextEditingController taskNameController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Mainscreen(),
  ));
}

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade500,
          title: const Text(
            "ToDo App ",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Itim', fontSize: 25),
          ),
        ),
        body: TabBarView(
          children: [
            Mainpart(),
            Mainpart(),
            Mainpart(),
          ],
        ),
      ),
    );
  }
}



