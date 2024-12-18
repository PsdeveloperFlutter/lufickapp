

// Screen 1: Post Screen
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';



RxList<dynamic>  imagelist = [
"assets/images/fluttersocial.jpg",
 "assets/images/ToDoLogo.jpg",
 "assets/images/ToDoLogo (2).jpg" ,
  "assets/images/ToDoLogo.jpg",
].obs;

RxList<dynamic>likeanddislike=[].obs;


class PostScreen extends StatefulWidget {

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin{


  void initState(){
    super.initState();
    //This is the logic for the list like and dislike purpose
    for(var value in imagelist){
      likeanddislike.add(0);
    }


  }


  @override
  void dispose(){
    super.dispose();
   }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.5),
        title: Text('Post'),
      ),
      body: Obx(() => ListView.builder(itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: screenHeight * 0.25,
                        width: screenWidth,
                        margin: EdgeInsets.all(screenWidth * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        )
                      ,child: Image.asset(imagelist[index]),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // Toggle between like and dislike
                          likeanddislike[index] =  likeanddislike[index] == 0 ? 1 : 0;
                        },
                        child:Obx(
                                () => GestureDetector(
                              onTap: () {
                                likeanddislike[index] = likeanddislike[index] == 0 ? 1 : 0; // Toggle like state
                              },
                              child:
                                   Icon(
                                    Icons.favorite,
                                    color: likeanddislike[index] == 0 ? Colors.blue : Colors.red,
                                  ),
                            ),
                            )
                        ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        );
      },itemCount: imagelist.length,),
    ),);
  }
}
