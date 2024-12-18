import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class friendlist extends StatefulWidget {

  @override
  State<friendlist> createState() => _friendlistState();
}

class _friendlistState extends State<friendlist> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 290,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                 child: Text(snapshot.data!.docs[index]['name'].toString().substring(0,1),style: TextStyle(fontSize: 12),),
                                ),

                              Text("${snapshot.data!.docs[index]['name'].toString()}",style: TextStyle(fontSize: 12),),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Followers :- ${snapshot.data!.docs[index]['follower'].toString()}"),
                                Text("Following :- ${snapshot.data!.docs[index]['following'].toString()}"),
                              ],
                            ),
                          ],
                        ),

                        ), ],
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return Divider();
            },
            );
          } else {
            return CircularProgressIndicator();
      }
    }),

    );
  }
}
