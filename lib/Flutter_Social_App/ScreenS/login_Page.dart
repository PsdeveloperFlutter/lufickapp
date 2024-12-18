import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Firebase_Related_Code/Google_Sign_In.dart';
import 'Main_Page.dart';
import 'User_Profile.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAbY4ZNAKoZEi600VFVbKSwej-fLwWLaT0",
        appId: "1:927174904612:android:51df47f716d24d1b39c1b1",
        messagingSenderId: "927174904612",
        projectId: "lufickinternship-d0d28",
        storageBucket: "lufickinternship-d0d28.firebasestorage.app",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Optionally, handle the error if necessary
  }

  // Now run your app
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.data==null){
              return LoginPages();
            }
            else{
            return HomeScreen();
            }
        }

        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        else{
          return LoginPages();
        }
      })));
}




//It is the Screen of Login

class LoginPages extends StatelessWidget {
  dynamic email,name;
  List<dynamic> value=[];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                    image: AssetImage("assets/images/fluttersocial.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: ()async{
           print("Login with Google");
           gs  obj=new gs();
           await obj.Signwithgoogle();
           email=gs.email;
           name=gs.name;
           if(email!=null   && name!=null){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfileScreen(username: name,email: email,)));
           }
            },
            child: Card(
              elevation: 3,
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Login with Google",style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Icon(Icons.login,color: Colors.blue,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              print("Login with Mobile Number");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            },
            child: Card(
              elevation: 3,
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Login with Mobile",style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Icon(Icons.login,color: Colors.blue,)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
