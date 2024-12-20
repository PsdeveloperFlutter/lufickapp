import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'login_Page.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController postcontroller=TextEditingController();


  void dispose(){
    super.dispose();
    postcontroller.dispose();
  }



  // Fetching and showing the data in the console
  Future<void> fetchProfile() async {
    final firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await firestore.collection("users").get();

      for (var value in snapshot.docs) {
        print("Document ID: ${value.id}");
        print("Data: ${value.data()}\n");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No data found."),
            );
          } else {
            final docs = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: Image.asset('assets/images/fluttersocial.jpg').image,
                              radius: 45,
                            ),
                            Positioned(
                              top: 60,
                              left: 60,
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade500,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white, size: 20)),
                            )
                          ],
                        ),
                        SizedBox(width: 18),
                        Column(
                          children: [
                            Text("${snapshot.data!.docs[0]['post'].length} "),
                            SizedBox(height: 5),
                            Text("posts"),
                          ],
                        ),
                        SizedBox(width: 18),
                        Column(
                          children: [
                            Text("${docs[0]['follower']}"),
                            SizedBox(height: 5),
                            Text("followers"),
                          ],
                        ),
                        SizedBox(width: 18),
                        Column(
                          children: [
                            Text("${docs[0]['following']}"),
                            SizedBox(height: 5),
                            Text("following"),
                          ],
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      docs[0]['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      docs[0]['bio'],
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 300,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Professional dashboard",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                Text(
                                  "New tools are now available",
                                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 10),
                            child: Text(
                              ".",
                              style: TextStyle(fontSize: 60, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Card(
                            elevation: 1,
                            child: Container(
                              color: Color(0xFFF5F5F5),
                              height: 40,
                              width: 120,
                              child: Center(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                  )),
                            ),
                          ),
                          SizedBox(width: 20),
                          Card(
                            elevation: 1,
                            child: Container(
                              color: Color(0xFFF5F5F5),
                              height: 40,
                              width: 120,
                              child: Center(
                                  child: Text(
                                    "Share Profile",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                  )),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: ()async{
                              try{

                                FirebaseFirestore instance = FirebaseFirestore.instance;
                                await instance.collection("users").doc(docs[0]['email']).delete();


                                // Perform logout action
                                await GoogleSignIn().signOut();
                                await FirebaseAuth.instance.signOut();
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPages()));
                              }
                              catch(e){
                                print("Error Occur :- $e");
                              }
                            },
                            child: Card(
                              elevation: 1,
                              child: Container(
                                color: Color(0xFFF5F5F5),
                                height: 40,
                                width: 120,
                                child: Center(
                                    child: Text(
                                      "logo Out",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Expanded(
                                child: AlertDialog(
                                  title: Text('Add Post'),
                                  content: Text('Are you sure you want to add a new post?',style: TextStyle(fontSize: 10),),
                                  actions: [
                                    Column(
                                      children: [
                                      TextField(
                                        controller:postcontroller,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.blue),

                                          ),
                                          labelText: 'Post',
                                        ),
                                      ),
                                      ],
                                    ),
                                    SingleChildScrollView(
                               scrollDirection: Axis.horizontal,
                               child: Row(
                                 children: [
                                   TextButton(
                                     onPressed: () {
                                       Navigator.of(context).pop();
                                     },
                                     child: Text('CANCEL'),
                                   ),
                                   SizedBox(width: 12,),
                                   TextButton(
                                     onPressed: () async{

                                       try{

                                         Map<dynamic,dynamic>newpost={
                                           "posts":postcontroller.text.toString().trim(),
                                           "like":0,
                                           "Dislike":0,
                                           "update":DateTime.now(),
                                           "Comments":[],
                                         };
                                         FirebaseFirestore instance = FirebaseFirestore.instance;


                                         await instance.collection("users").doc(docs[0]['email']).update(

                                             {"post":FieldValue.arrayUnion([newpost]) });
                                         Navigator.of(context).pop();
                                       }
                                       catch(e){
                                         print("Error Occur :- $e");
                                       }
                                     },
                                     child: Text('ACCEPT'),
                                   ),
                                 ],
                               ),
                             )
                                  ],
                                ),
                              );
                            },
                          );


                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "New Post",
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.collections, size: 25, color: Colors.black45),
                      Icon(Icons.video_call, size: 25, color: Colors.black45),
                      Icon(Icons.perm_identity, size: 25, color: Colors.black45),
                    ],
                  ),
                  SizedBox(height: 12),

              StreamBuilder(stream: FirebaseFirestore.instance.collection("users").snapshots(), builder:(context,snapshot){
                if(snapshot.hasError){
                  return Center(child: Text("Error Occur :- ${snapshot.error}"));
                }
                else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Center(child: Text("No data found"));
                }

                else {
                  return
                  SizedBox(
                    height: 300, // Constrain height to avoid render errors
                    child: snapshot.hasData && snapshot.data!.docs.isNotEmpty
                        ? ListView.separated(

                      itemCount: docs[0]['post'].length,
                      itemBuilder: (context, index) {
                        var post = docs[0]['post'][index]['posts'].toString();
                        dynamic like = docs[0]['post'][index]['like'].toString();
                        var Dislike = docs[0]['post'][index]['Dislike'].toString();

                        final createdAt =snapshot.data!.docs[0]['createdat']; // Assuming createdat is stored per post
                        DateTime? createdDate;

                        // Convert timestamp to DateTime if it's a valid type
                        if (createdAt is Timestamp) {
                          createdDate = createdAt.toDate();
                        } else if (createdAt is String) {
                          try {
                            createdDate = DateTime.parse(createdAt);
                          } catch (e) {
                            createdDate = null;
                          }
                        }

                        final formattedDate = createdDate != null
                            ? "${createdDate.day}-${createdDate.month}-${createdDate.year} \n Hours ${DateTime.now().hour} \n Minutes ${DateTime.now().minute}"
                            : "Invalid date";

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            post.isNotEmpty ? post : 'N/A',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),


                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center, // Aligns children vertically
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes children evenly
                                      children: [
                                        // Like Column
                                        Column(
                                          mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                print("Document ID: ${docs[0]['post'].length}");
                                                Future<void> updateLikeField(String docId, int postIndex) async {
                                                  try {
                                                    // Reference the document
                                                    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(docId)
                                                        .get();

                                                    if (docSnapshot.exists) {
                                                      // Fetch the current 'post' array
                                                      List<dynamic> postArray = docSnapshot.get("post");

                                                      // Check if the index is valid
                                                      if (postIndex >= 0 && postIndex < postArray.length) {
                                                        // Increment the 'like' value
                                                        postArray[postIndex]["like"] = (postArray[postIndex]["like"] ?? 0) + 1;

                                                        // Update the document in Firestore
                                                        await FirebaseFirestore.instance
                                                            .collection("users")
                                                            .doc(docId)
                                                            .update({"post": postArray});

                                                        print("Like count updated successfully!");
                                                      } else {
                                                        print("Invalid post index.");
                                                      }
                                                    } else {
                                                      print("Document does not exist.");
                                                    }
                                                  } catch (e) {
                                                    print("Error updating like count: $e");
                                                  }
                                                }
                                                print("Document ID: ${docs[0]['post'].length - 1}");

                                                //Call of the functon
                                                updateLikeField(snapshot.data!.docs[index].id, index);

                                              },
                                              icon: Icon(Icons.thumb_up, color: Colors.red),
                                            ),

                                            Text(
                                              docs[0]['post'][index]['like'].toString(),
                                              style: TextStyle(color: Colors.red),
                                            ),

                                          ],
                                        ),
                                        // Dislike Column
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Future<void> updateDisLikeField(String docId, int postIndex) async {
                                                  try {
                                                    // Reference the document
                                                    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(docId)
                                                        .get();

                                                    if (docSnapshot.exists) {
                                                      // Fetch the current 'post' array
                                                      List<dynamic> postArray = docSnapshot.get("post");

                                                      // Check if the index is valid
                                                      if (postIndex >= 0 && postIndex < postArray.length) {
                                                        // Increment the 'like' value
                                                        postArray[postIndex]["Dislike"] = (postArray[postIndex]["Dislike"] ?? 0) + 1;

                                                        // Update the document in Firestore
                                                        await FirebaseFirestore.instance
                                                            .collection("users")
                                                            .doc(docId)
                                                            .update({"post": postArray});

                                                        print("DisLike count updated successfully!");
                                                      } else {
                                                        print("Invalid post index.");
                                                      }
                                                    } else {
                                                      print("Document does not exist.");
                                                    }
                                                  } catch (e) {
                                                    print("Error updating like count: $e");
                                                  }
                                                }


                                                //Call of the functon
                                                updateDisLikeField(snapshot.data!.docs[index].id, index);
                                              },
                                              icon: Icon(Icons.thumb_down, color: Colors.blue),
                                            ),
                                            Text(
                                              "${Dislike.toString()}",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        // Update Column
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Add Post'),
                                                      content: Text(
                                                        'Are you sure you want to Update your post?',
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                      actions: [
                                                        TextField(
                                                          controller: postcontroller,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                              borderSide: BorderSide(color: Colors.blue),
                                                            ),
                                                            labelText: 'Post',
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('CANCEL'),
                                                            ),
                                                            SizedBox(width: 12),
                                                            TextButton(
                                                              onPressed: () async {
                                                                try {
                                                                  FirebaseFirestore instance =
                                                                      FirebaseFirestore.instance;

                                                                  DocumentSnapshot docSnapshot = await instance
                                                                      .collection("users")
                                                                      .doc(docs[0]['email'])
                                                                      .get();

                                                                  if (docSnapshot.exists) {
                                                                    List<dynamic> postArray =
                                                                    docSnapshot.get("post");
                                                                    int indexToUpdate = index;
                                                                    String newValue =
                                                                    postcontroller.text.trim();

                                                                    if (indexToUpdate >= 0 &&
                                                                        indexToUpdate < postArray.length) {
                                                                      postArray[indexToUpdate] = newValue;

                                                                      await instance
                                                                          .collection("users")
                                                                          .doc(docs[0]['email'])
                                                                          .update({"post": postArray});

                                                                      Navigator.of(context).pop();
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            content: Text("Post updated successfully!")),
                                                                      );
                                                                    } else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            content: Text("Invalid index. Please try again.")),
                                                                      );
                                                                    }
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(
                                                                          content: Text("User document not found.")),
                                                                    );
                                                                  }
                                                                } catch (e) {
                                                                  print("Error updating post array: $e");
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                        content: Text("Failed to update post. Please try again.")),
                                                                  );
                                                                }
                                                              },
                                                              child: Text('ACCEPT'),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(Icons.update, color: Colors.red.shade400, size: 25),
                                            ),
                                          ],
                                        ),
                                        // Delete Column
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Delete'),
                                                      content: Text('Are you sure you want to Delete Post'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('CANCEL'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore.instance
                                                                .collection("users")
                                                                .doc(docs[0]['email'])
                                                                .update(
                                                                {"post": FieldValue.arrayRemove([post])});
                                                          },
                                                          child: Text('ACCEPT'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(Icons.delete, color: Colors.blue.shade400, size: 25),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                     return   Divider();
                    },
                    )

                        : Center(child: Text('No data available',style: TextStyle(color: Colors.black),)),
                  );

                }
              })


               ],
              ),
            );
          }
        },
      ),
    );
  }
}
