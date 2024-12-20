import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lufickapp/Flutter_Social_App/ScreenS/login_Page.dart';

RxList<dynamic> imagelist = [
  "assets/images/nature1..jpg",
  "assets/images/nature2.jpg",
  "assets/images/nature3.jpg",
  "assets/images/nature4.jpg",
].obs;

RxList<int> likeanddislike = RxList<int>();
RxList<bool> isPostVisible = RxList<bool>();
RxList<String> postTimes = RxList<String>();

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPages()));
          },
          child: Text('Post'),
        ),
      ),
      body: StreamBuilder(stream:FirebaseFirestore.instance.collection("users").snapshots() ,

          builder: (context,index){

            if(index.hasError){
              return Center(child: Text("Error Occur :- ${index.error}"));
            }

            else if(!index.hasData || index.data!.docs.isEmpty){
              return Center(child: Text("No data found"));
            }



            //This is the User Post List Of all Person Which Is Available on the App
            else {
              return ListView.builder(

              )



            }
      })
    );
  }
}
