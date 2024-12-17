import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lufickapp/Flutter_Social_App/ScreenS/Otp_Screen/otpscreen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Otp Screen'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: controller,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.phone),
                    suffixIconColor: Colors.black,
                    hintStyle: TextStyle(color: Colors.blue),
                    hintText: "Enter phone number",
                    labelStyle: TextStyle(color: Colors.blue),
                    labelText: "Enter phone number ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () async{

              //Calling of the function OF Generate otp
              otpgenerate();

            }, child: Text("Generate OTP"))
          ],
        ));
  }


  //This is the function for generate otp
  Future<void> otpgenerate() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex) {},
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => otpscreen(
            verificationid: verificationId,
          )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        phoneNumber: controller.text.trim().toString());
  }
}
