import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZoomDrawerScreen(),
    );
  }
}

class ZoomDrawerScreen extends StatelessWidget {
  final ZoomDrawerController drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: drawerController,
      menuScreen: MenuScreen(drawerController), // Sidebar Menu
      mainScreen: MainScreen(drawerController), // Main Content
      borderRadius: 24.0,
      showShadow: true,
      angle: -5.0,
      slideWidth: MediaQuery.of(context).size.width *0.8, // Adjust drawer width
    );
  }
}

// Sidebar Menu
class MenuScreen extends StatelessWidget {
  final ZoomDrawerController controller;
  MenuScreen(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text("Menu", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
              Divider(color: Colors.white54),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text("Home", style: TextStyle(color: Colors.white)),
                onTap: () {
                  controller.close!();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: () {
                  controller.close!();
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {
                  controller.close!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Content
class MainScreen extends StatelessWidget {
  final ZoomDrawerController controller;
  MainScreen(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zoom Drawer"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            controller.toggle?.call();
          },
        ),
      ),
      body: Center(
        child: Text("Main Screen", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
