import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

//Animated Floating Action Button
class SimpleFab extends StatefulWidget {
  @override
  State<SimpleFab> createState() => _SimpleFabState();
}

class _SimpleFabState extends State<SimpleFab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(
        onPressed: () {},
        child:SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
              label: "Add"
            ),
            SpeedDialChild(
                child: Icon(Icons.call),
                label: "Call"
            ),
            SpeedDialChild(
                child: Icon(Icons.access_alarms),
                label: "Alarm"
            ),
            SpeedDialChild(
                child: Icon(Icons.menu),
                label: "Menu"
            ),
          ],
        )
      ),
    );
  }
}
void main(){
  runApp(MaterialApp(home:SimpleFab(),));
}