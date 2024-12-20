import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lufickapp/Flutter_Social_App/ScreenS/login_Page.dart';



class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: GestureDetector(
          onTap: () async {
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPages()));
          },
          child: Text('Post'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error Occur :- ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No data found"));
            }

            // Extract Firestore data
            final users = snapshot.data!.docs;

            return Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.separated(
                  itemCount:snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                  return Card(
                    elevation: 5,
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.cyanAccent.shade100,
                                radius: 30,
                                child: Text(users[index]['name'][0].toString(),style: TextStyle(color: Colors.black),),
                              ),
                              Text(users[index]['name'].toString()),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text("Post", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
                          SizedBox(height: 4,),
                          Text(users[index]['post'][index]['posts'].toString()),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Column(
                               children: [
                                 IconButton(onPressed: (){}, icon: Icon(Icons.thumb_up,color: Colors.red,)),
                                 Text(users[index]['post'][index]['like'].toString()),
                               ],
                             ),
                             Column(
                               children: [
                                 IconButton(onPressed: (){}, icon: Icon(Icons.thumb_down,color: Colors.blue,)),
                                 Text(users[index]['post'][index]['Dislike'].toString()),
                               ],
                             )
                             ,
                             Column(
                               children: [
                                 IconButton(onPressed: (){}, icon: Icon(Icons.thumb_down,color: Colors.blue,)),
                                 Text(users[index]['post'][index]['Dislike'].toString()),
                               ],
                             )
                           ],
                         )

                        ],
                      ),),
                    )
                  );

                  }, separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                },
                ),
              ),
            );
          }),
    );
  }
}
