import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Main_Page.dart';

class otpscreen extends StatefulWidget {

  dynamic verificationid;

  otpscreen({required this.verificationid});

  @override
  State<otpscreen> createState() => _otpscreenState();
}

class _otpscreenState extends State<otpscreen> {
  TextEditingController otpcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Otp Screen'),
        ),
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: otpcontroller,
                decoration: InputDecoration(
                  suffixIconColor: Colors.black,
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  labelText: 'Enter Otp',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
              ),
            )
            ,
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()async{
              //Verify the otp came from the firebase
              verifyotp();
            }, child: Text("Verify Otp"))
          ],
        ),
      );
  }


  Future<void> verifyotp()async{
    try{

      PhoneAuthCredential credential=await PhoneAuthProvider.credential(verificationId: widget.verificationid, smsCode: otpcontroller.text.toString());
      await FirebaseAuth.instance.signInWithCredential(credential).then((value){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      });
    }catch(e){
    print(" Error Occur \n:$e");
    }



  }
}
