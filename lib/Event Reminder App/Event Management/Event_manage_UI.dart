import 'package:flutter/material.dart';
// class to build the app
class Mainpage_event_management extends StatelessWidget {

// build the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.music_note,color: Colors.white,)),
                Tab(icon: Icon(Icons.music_video,color: Colors.white,)),
                Tab(icon: Icon(Icons.camera_alt,color: Colors.white,)),
                Tab(icon: Icon(Icons.grade,color: Colors.white,)),
                Tab(icon: Icon(Icons.email,color: Colors.white,)),
              ],
            ), // TabBar
            title: const Text('Event Remainder App',style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.green,
          ), // AppBar
          body: TabBarView(
            children: [
              // Tab 1: Static Icon
              const Center(child: Icon(Icons.music_note, size: 50)),

              // Tab 2: Static Icon
             Event_creation_UI(context),

              // Tab 3: Static Icon
              const Center(child: Icon(Icons.grade, size: 50,)),

              // Tab 4: Static Icon
              const Center(child: Icon(Icons.grade, size: 50)),

              // Tab 5: Static Icon
              const Center(child: Icon(Icons.email, size: 50)),
            ],
          ), // TabBarView
        ), // Scaffold
      ), // DefaultTabController
    ); // MaterialApp
  }

 Widget Event_creation_UI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(text: TextSpan(
              text: " Create an Event",
              style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: " \n to be Reminded",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 20),
                )
              ]
            )),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade700,width: 25.0),
                ),
                suffixIcon: Icon(Icons.event,color: Colors.black45,),
                hintText: "Enter the name of the event",
                hintStyle: TextStyle(color: Colors.blue.shade700),
                label: Text("Event Name"),
                labelStyle: TextStyle(color: Colors.blue.shade700),

              ),
            ),
          ),// It is for the event name

          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade700,width: 25.0),
                ),
                suffixIcon: Icon(Icons.event,color: Colors.black45,),
                hintText: "Enter Date and Time of the event",
                hintStyle: TextStyle(color: Colors.blue.shade700),
                label: Text("Event Date and Time"),
                labelStyle: TextStyle(color: Colors.blue.shade700),

              ),
            ),
          ),//It is for the date and Time

          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade700,width: 25.0),
                ),
                suffixIcon: Icon(Icons.event,color: Colors.black45,),
                hintText: "Enter the Location of the event",
                hintStyle: TextStyle(color: Colors.blue.shade700),
                label: Text("Event Location"),
                labelStyle: TextStyle(color: Colors.blue.shade700),

              ),
            ),
          ), //It is for the location

          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade700,width: 25.0),
                ),
                suffixIcon: Icon(Icons.event,color: Colors.black45,),
                hintText: "Enter the description of the event",
                hintStyle: TextStyle(color: Colors.blue.shade700),
                label: Text("Event Description"),
                labelStyle: TextStyle(color: Colors.blue.shade700),

              ),
            ),
          ),  //It is for the Description of the event


          //This is for the Selection of the Phote and Media And Files in the Code User can fetch the data and select the data and store in the Database After Selection of the Data

          SizedBox(height: 12,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.photo_album,color: Colors.deepOrange,)),
                      Text("Photo",style: TextStyle(color: Colors.deepPurple),)
                    ],
                  ),
                ),
                SizedBox(width: 12,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.video_call,color: Colors.deepOrange,)),
                      Text("Video",style: TextStyle(color: Colors.deepPurple),)
                    ],
                  ),
                ),
                SizedBox(width: 12,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.edit_document,color: Colors.deepOrange,)),
                      Text("File",style: TextStyle(color: Colors.deepPurple),)
                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
 }
}
