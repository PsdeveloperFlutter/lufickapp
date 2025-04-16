import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'CRUD_fetch.dart';

class CRUDCreate extends StatefulWidget {
  const CRUDCreate({Key? key}) : super(key: key);

  @override
  State<CRUDCreate> createState() => _CRUDCreateState();
}

class _CRUDCreateState extends State<CRUDCreate> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _image;  // To store the selected image
  final ImagePicker _picker = ImagePicker(); // To pick images from gallery

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);  // Set the picked image
      });
    }
  }

  // Method to send the user data and image to the server
  void createuser_data() async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields and select an image"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      final url = Uri.parse('http://192.168.29.65:3000/savedata');

      // Prepare the multipart request
      var request = http.MultipartRequest('POST', url);

      // Add text fields (name, age, email, phone)
      request.fields['name'] = nameController.text.trim();
      request.fields['age'] = ageController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['phone'] = phoneController.text.trim();

      // Add the image file
      var imageFile = await http.MultipartFile.fromPath('image', _image!.path);
      request.files.add(imageFile);

      try {
        // Send the request
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User created successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create user: ${response.statusCode}'),
            ),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),

                // Button to pick image
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),

                // Show picked image if available
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(_image!),
                  ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: createuser_data,
                  child: Text('Create User'),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return FetchDataScreen();
                    }));
                  },
                  child: Text('Get User'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CRUDCreate(),
  ));
}
