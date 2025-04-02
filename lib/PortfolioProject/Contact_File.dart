import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  double _opacity = 0.0; // For fade-in animation

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Me"),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// Profile Image at the Top Center
          Positioned(
            top: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/ghibli-transformed-1743487333821.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /// Contact Form with Animation
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: _opacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 140, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimatedTextField("Your Name", Icons.person),
                      SizedBox(height: 15),
                      _buildAnimatedTextField("Your Email", Icons.email, keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 15),
                      _buildAnimatedTextField("Subject", Icons.subject),
                      SizedBox(height: 15),
                      _buildAnimatedTextField("Message", Icons.message, maxLines: 5),
                      SizedBox(height: 20),
                      _buildAnimatedSubmitButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField(String hintText, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      tween: Tween<double>(begin: 50.0, end: 0.0),
      curve: Curves.easeOut,
      builder: (context, double offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $hintText';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubmitButton() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      tween: Tween<double>(begin: 100.0, end: 0.0),
      curve: Curves.easeOut,
      builder: (context, double offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Message Sent Successfully!")),
                  );
                }
              },
              child: Text("Send Message", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        );
      },
    );
  }
}
