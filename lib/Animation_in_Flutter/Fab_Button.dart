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
     floatingActionButton: FloatingActionButton(
         onPressed: () {},
         child:SpeedDial(
           overlayColor: Colors.blue.shade500,
           overlayOpacity:0.4,
           animatedIcon: AnimatedIcons.menu_close,
           children: [
             SpeedDialChild(
                 backgroundColor: Colors.yellow,
                 child: Icon(Icons.add),
                 label: "Add"
                 ,onTap: (){
               print("Priyanshu satija1");
             }
             ),
             SpeedDialChild(
                 backgroundColor: Colors.blue,
                 child: Icon(Icons.call),
                 label: "Call"
                 ,onTap: (){
               print("Priyanshu satija2");
             }
             ),
             SpeedDialChild(
                 backgroundColor: Colors.greenAccent,
                 child: Icon(Icons.access_alarms),
                 label: "Alarm"
                 ,onTap: (){
               print("Priyanshu satija3");
             }
             ),
             SpeedDialChild(
                 backgroundColor: Colors.green,
                 child: Icon(Icons.menu),
                 label: "Menu"
                 ,onTap: (){
               print("Priyanshu satija4");
             }
             ),
           ],
         )
     ),
      body: Center(child: Text("Priyanshusatija"))
    );
  }
}
void main(){
  runApp(MaterialApp(home:SimpleFab(),));
}