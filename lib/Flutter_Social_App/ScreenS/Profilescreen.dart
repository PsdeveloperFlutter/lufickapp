import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Fetching and showing the data in the console
  Future<void> fetchProfile() async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await firestore.collection("users").get();

      for (var value in snapshot.docs) {
        print("Document ID: ${value.id}");
        print("Data: ${value.data()}\n");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No data found."),
            );
          } else {
            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final datadocs = docs[index].data() as Map<String, dynamic>;

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(datadocs["image"] ?? "https://via.placeholder.com/150"),
                        onBackgroundImageError: (_, __) => Text('Image Error'),
                      ),
                      title: Text(datadocs["name"].toString()),
                      subtitle: Text(datadocs["email"].toString()),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
