import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final datadocs = docs[index].data() as Map<String, dynamic>;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    child: Icon(Icons.add,color: Colors.white,size: 20,)),
                              )
                            ],
                          )
                         ,
                          SizedBox(width: 18,),
                          Column(
                            children: [
                              Text("3"),
                              SizedBox(height: 5,),
                              Text("posts")
                            ],
                          ),
                          SizedBox(width: 18,),
                          Column(
                            children: [
                              Text("263"),
                              SizedBox(height: 5,),
                              Text("followers")
                            ],
                          ),
                          SizedBox(width: 18,),
                          Column(
                            children: [
                              Text("204"),
                              SizedBox(height: 5,),
                              Text("following")
                            ],
                          ),
                          SizedBox(width: 10,),


                        ],
                      ),
                    ),



                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(datadocs['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(datadocs['bio'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                    ),

                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        width: 300,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5) // 50% transparency
                          ,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the children
                          crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10), // Add some padding to the text
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
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
                              padding: const EdgeInsets.only(right: 20, left: 10), // Space to the right
                              child: Text(
                                ".",
                                style: TextStyle(fontSize: 60, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
,
        SizedBox(height: 12,),


                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Container(
                        child: Row(
                          children: [
                            Card(
                              elevation: 1,
                              child: Container(
                                color:  Color(0xFFF5F5F5),
                                height: 40,
                                width: 120,
                                child: Center(child: Text("Edit Profile",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),)),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Card(
                              elevation: 1,
                              child: Container(
                                color:  Color(0xFFF5F5F5),
                                height: 40,
                                width: 120,
                                child: Center(child: Text("Share Profile",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 12,),
                   Column(
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           width: 82,
                           height: 82,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(45),
                             border: Border.all(color: Colors.black),
                           ),
                           child: Icon(Icons.add,size:50,color: Colors.black,),
                         ),
                       ),
                       SizedBox(height: 5,),
                       Text("New Post",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),)
                     ],
                   )



                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
