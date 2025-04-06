import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:particles_fly/particles_fly.dart';
import 'package:url_launcher/url_launcher.dart';
class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Projects", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,

      ),
      body: Stack(
        children: [
          // Background particle animation
          ParticlesFly(
            connectDots: true,
            numberOfParticles: 80,
            isRandomColor: true,
            isRandSize: true,
            maxParticleSize: 15.0,
            particleColor: Colors.cyanAccent,
            speedOfParticles: 8.0,
            randColorList: [
              Colors.blue.shade700,
              Colors.redAccent.shade700,
              Colors.deepOrange.shade700,
              Colors.yellowAccent.shade700,
              Colors.greenAccent.shade700,
              Colors.blueGrey.shade700,
            ],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) => _buildAnimatedProjectCard(index)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProjectCard(int  title) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_rotationAnimation.value)
            ..setEntry(3, 2, 0.002)
            ..rotateX(_rotationAnimation.value),
          child: title==0?

          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                           "Project :- ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text("Recipe App ",

                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("Description",
                    style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.white),),
                    SizedBox(height: 15,),

                Text("It is my Recipe App which I create using help of Flutter and Dart and \n in this app I set the API of Food Recipe Meal DB api in which I fetch the various kind of the food Recipe and set the database for storing the Recipe method of the Particular Food and user Can have various Food Meal Recipe .",
                style: GoogleFonts.aBeeZee(fontSize: 13,color: Colors.white),
                )

                    ,       SizedBox(height: 15,),
                    ExpansionTile(
                      title: Text(
                        "Tech Stack Used",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "1. Flutter",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                          ),

                        ListTile(
                          title: Text(
                            "2. Dart",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "3. Sqflite Database",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "4. API",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "5. Material Design",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                  ],
                ),

                    SizedBox(height: 12,),

                Row(
                  children: [
                    Text("GitHub Link :- ",style: GoogleFonts.
                    aBeeZee(fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),)


                ,
                // Add this inside your Row widget at the cursor position
                GestureDetector(
                  onTap: () async {
                    const url = 'https://github.com/PsdeveloperFlutter/Project.git';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Open GitHub Project",
                    style: GoogleFonts.aBeeZee(fontSize: 15,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                  ],
                )

                ],
                            ),
              ),
            ),
          ):



//This is for the Project 1 make sure of that
          title==1?


          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Project :- ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text("Event Remainder App",

                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("Description",
                      style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.white),),
                    SizedBox(height: 15,),

                    Text("Hii it is my another Project in which I set their Event  and set the Remainder for the Future Event and set date and time for particular Event Which is Usefully for the user to stay update with their Events.",
                      style: GoogleFonts.aBeeZee(fontSize: 13,color: Colors.white),
                    )

                    ,       SizedBox(height: 15,),
                    ExpansionTile(
                      title: Text(
                        "Tech Stack Used",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "1. Flutter",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "2. Dart",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "3. Sqflite Database",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "4. Local Notification ",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "5. Material Design",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "6. Firebase",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 12,),

                    Row(
                      children: [
                        Text("GitHub Link :- ",style: GoogleFonts.
                        aBeeZee(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),)


                        ,
                // Add this inside your Row widget at the cursor position
                        GestureDetector(
                          onTap: () async {
                            const url = 'https://github.com/PsdeveloperFlutter/lufickapp.git';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            "Open GitHub Project",
                            style: GoogleFonts.aBeeZee(fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ),
          ):




          title==2?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Project :- ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text("Weather App",

                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("Description",
                      style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.white),),
                    SizedBox(height: 15,),

                    Text("Hii it is my another Project in which  user can see the weather of particular city and with the help of the Weather API through this api I fetch data and show to the user.",
                      style: GoogleFonts.aBeeZee(fontSize: 13,color: Colors.white),
                    )

                    ,       SizedBox(height: 15,),
                    ExpansionTile(
                      title: Text(
                        "Tech Stack Used",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "1. Flutter",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "2. Dart",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "3. Sqflite Database",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "4. Local Notification ",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "5. Material Design",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "6. Firebase",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 12,),

                    Row(
                      children: [
                        Text("GitHub Link :- ",style: GoogleFonts.
                        aBeeZee(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),)


                        ,
                        // Add this inside your Row widget at the cursor position
                        GestureDetector(
                          onTap: () async {
                            const url = 'https://github.com/PsdeveloperFlutter/lufickapp.git';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            "Open GitHub Project",
                            style: GoogleFonts.aBeeZee(fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ),
          ):


              //This is for the 2 project make sure of that and so on
         title==3?


         Container(
           margin: EdgeInsets.symmetric(horizontal: 15.0),
           width: 350,
           height: 400,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [Colors.deepPurple, Colors.purpleAccent],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
             ),
             borderRadius: BorderRadius.circular(25),
             boxShadow: [
               BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
             ],
           ),
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: [
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         Text(
                           "Project :- ",
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                         Text("Ecommerce App",

                           style: GoogleFonts.poppins(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         )
                       ],
                     ),
                   ),
                   SizedBox(height: 15,),
                   Text("Description",
                     style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.white),),
                   SizedBox(height: 15,),

                   Text("Hii it is my another Project Ecommerce App name is Urban Cart where User can search short the products and add to cart and "
                       "set the UPI payment with help of the Phone Pay and Paytm and many more thinks .",
                     style: GoogleFonts.aBeeZee(fontSize: 13,color: Colors.white),
                   )

                   ,       SizedBox(height: 15,),
                   ExpansionTile(
                     title: Text(
                       "Tech Stack Used",
                       style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                     ),
                     children: [
                       ListTile(
                         title: Text(
                           "1. Flutter",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "2. Dart",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "3. Sqflite Database",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "4. Node js",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "5. Material Design",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),
                       ListTile(
                         title: Text(
                           "6. Firebase",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),
                       ListTile(
                         title: Text(
                           "7. Express Js",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "8. UPI Payments",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),
                     ],
                   ),

                   SizedBox(height: 12,),

                   Row(
                     children: [
                       Text("GitHub Link :- ",style: GoogleFonts.
                       aBeeZee(fontSize: 15,
                           fontWeight: FontWeight.bold,
                           color: Colors.white),)


                       ,
                       // Add this inside your Row widget at the cursor position
                       GestureDetector(
                         onTap: () async {
                           const url = 'https://github.com/PsdeveloperFlutter/lufickapp.git';
                           if (await canLaunch(url)) {
                             await launch(url);
                           } else {
                             throw 'Could not launch $url';
                           }
                         },
                         child: Text(
                           "Open GitHub Project",
                           style: GoogleFonts.aBeeZee(fontSize: 15,
                               color: Colors.white,
                               decoration: TextDecoration.underline,
                               fontWeight: FontWeight.bold),
                         ),
                       ),

                     ],
                   )

                 ],
               ),
             ),
           ),
         ):





         Container(
           margin: EdgeInsets.symmetric(horizontal: 15.0),
           width: 350,
           height: 400,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [Colors.deepPurple, Colors.purpleAccent],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
             ),
             borderRadius: BorderRadius.circular(25),
             boxShadow: [
               BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
             ],
           ),
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: [
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         Text(
                           "Project :- ",
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                         Text("Weather App",

                           style: GoogleFonts.poppins(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         )
                       ],
                     ),
                   ),
                   SizedBox(height: 15,),
                   Text("Description",
                     style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.white),),
                   SizedBox(height: 15,),

                   Text("Hii it is my another Project in which  user can see the weather of particular city and with the help of the Weather API through this api I fetch data and show to the user.",
                     style: GoogleFonts.aBeeZee(fontSize: 13,color: Colors.white),
                   )

                   ,       SizedBox(height: 15,),
                   ExpansionTile(
                     title: Text(
                       "Tech Stack Used",
                       style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
                     ),
                     children: [
                       ListTile(
                         title: Text(
                           "1. Flutter",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "2. Dart",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "3. Sqflite Database",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "4. Local Notification ",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "5. Material Design",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                       ListTile(
                         title: Text(
                           "6. Firebase",
                           style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                         ),
                       ),

                     ],
                   ),

                   SizedBox(height: 12,),

                   Row(
                     children: [
                       Text("GitHub Link :- ",style: GoogleFonts.
                       aBeeZee(fontSize: 15,
                           fontWeight: FontWeight.bold,
                           color: Colors.white),)


                       ,
                       // Add this inside your Row widget at the cursor position
                       GestureDetector(
                         onTap: () async {
                           const url = 'https://github.com/PsdeveloperFlutter/lufickapp.git';
                           if (await canLaunch(url)) {
                             await launch(url);
                           } else {
                             throw 'Could not launch $url';
                           }
                         },
                         child: Text(
                           "Open GitHub Project",
                           style: GoogleFonts.aBeeZee(fontSize: 15,
                               color: Colors.white,
                               decoration: TextDecoration.underline,
                               fontWeight: FontWeight.bold),
                         ),
                       ),

                     ],
                   )

                 ],
               ),
             ),
           ),
         )

        );
      },
    );
  }
}