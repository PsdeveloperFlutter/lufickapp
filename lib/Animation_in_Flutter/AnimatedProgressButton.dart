import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({super.key});

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  @override
  Widget build(BuildContext context) {
    bool isloading=true;
    return
        Scaffold(
          body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(32),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24),
                      minimumSize: Size.fromHeight(72),
                      shape: StadiumBorder()),
                      onPressed: ()async{
                        if(isloading)return;


                        setState(() {
                          isloading=true;
                        });

                        await Future.delayed(Duration(seconds: 5));
                        setState(() {
                          isloading=false;
                        });
                      }, child: isloading?

                  Row(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(width: 24,),
                      Text("Please Wait....")
                    ],
                  ):Text("Login")

                  ),
                ),
              ),
            ],
          ),
        );
  }
}


void main(){
runApp(MaterialApp(home:ProgressButton()));
}