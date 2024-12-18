import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to save user profile
  void _saveProfile() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String bio = _bioController.text.trim();
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        _profileImage == null ||
        bio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Please complete all fields and upload a profile picture")),
      );
    } else {
      Future<void> addprofileinfsb() async {
        final firestore = await FirebaseFirestore.instance;
        await firestore
            .collection("users")
            .doc(email)
            .set({
              "name": name,
              "email": email,
              "phone": phone,
              "bio": bio,
              "image": _profileImage?.path,
              "createdat": FieldValue.serverTimestamp()
            })
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Profile saved successfully!"))))
            .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to save profile"))));
      }

      addprofileinfsb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.5),
        title: Text("Create Profile",style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Card for the Form Section
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
              //      color: Colors.cyanAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(
                    minHeight: 200,
                    maxHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height:
                                40), // To create space for the profile image
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            prefixIconColor: Color(0xFF2196F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(color: Colors.blue.shade500),
                            hintText: 'Enter your name',
                            labelText: 'Name',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Color(0xFF2196F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(color: Colors.blue.shade500),
                            hintText: 'Enter your email',
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            prefixIconColor: Color(0xFF2196F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(color: Colors.blue.shade500),
                            hintText: 'Enter your phone number',
                            labelText: 'Phone',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            prefixIconColor: Color(0xFF2196F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(color: Colors.blue.shade500),
                            hintText: 'Enter your Bio',
                            labelText: 'Bio',
                          ),
                        ),
                        SizedBox(height: 30),
                        TextButton(
                          onPressed: _saveProfile,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Profile Image Section
            Positioned(
              top: 10,
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple.withOpacity(0.5),
                  radius: 44,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 25,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
