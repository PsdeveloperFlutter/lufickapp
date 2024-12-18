// Flutter code implementing a bottom navigation bar with three screens (Post, Profile, Update Post)
// Using MediaQuery for responsive design

import 'package:flutter/material.dart';

import 'Otp_Screen/Add friend list.dart';
import 'PostScreen.dart';
import 'Profilescreen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index of the currently selected screen
  int _selectedIndex = 0;

  // List of widgets for each screen
  final List<Widget> _screens = [
    PostScreen(),
    ProfileScreen(),
    friendlist(),
  ];

  // Method to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add,color: Colors.black),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.black),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.black),
            label: 'Friends List',
          ),
        ],
      ),
    );
  }
}




