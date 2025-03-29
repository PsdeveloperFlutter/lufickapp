import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
          },
          child: Text("Go to About Section"),
        ),
      ),
    );
  }
}

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> animationsColor;


  late AnimationController animationControllerofsize;

  late Animation<double> animationsSize;



  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationsColor = ColorTween(begin: Colors.pink, end: Colors.blue)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Delayed animation start after navigation
    Future.delayed(Duration(seconds: 5), () {
      _animationController.forward();
    });

    _animationController.addListener(() {
      setState(() {});
    });




    //Here I set the Animation for the Size make sure of that When the USER Came here so the size will starting change make sure of that


    animationControllerofsize = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationsSize = Tween<double>(begin: 100, end: 200)
        .animate(CurvedAnimation(parent: animationControllerofsize, curve: Curves.easeInOut));
    //here set the future delayed option here make sure of that
    Future.delayed(Duration(seconds: 3), () {
      animationControllerofsize.forward();
    });

    animationControllerofsize.addListener(() {
      setState(() {});
    });


  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width * 0.9,
              height: animationsSize.value,
              margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: animationsColor.value,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
              child: animationsSize.value>100
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dev Guru",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Flutter Developer | AI Enthusiast",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "I am a passionate Flutter developer with expertise in AI integrations, state management, and UI/UX design. I love creating modern and interactive mobile applications.",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
                  : null,
            ),
            Positioned(
              top: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {

                    animationControllerofsize.animateTo(animationsSize.value > 100 ? 100 : MediaQuery.of(context).size.height * 0.6);
                  });
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
