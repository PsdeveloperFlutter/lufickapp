// Flutter code implementing a bottom navigation bar with three screens (Post, Profile, Update Post)
// Using MediaQuery for responsive design

import 'package:flutter/material.dart';

import 'PostScreen.dart';
import 'Profilescreen.dart';
import 'User_Profile.dart';

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
    UserProfileScreen(),
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
            icon: Icon(Icons.perm_identity ,color: Colors.black,),
            label: 'Create Profile',

          ),
        ],
      ),
    );
  }
}





// Screen 3: Update Post Screen
class UpdatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
      ),
      body: Center(
        child: Text(
          'This is the Update Post Screen',
          style: TextStyle(
            fontSize: screenHeight * 0.025, // Responsive font size
          ),
        ),
      ),
    );
  }
}
