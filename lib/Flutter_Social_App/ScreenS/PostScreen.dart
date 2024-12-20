import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: Text('User Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error Occurred: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No users found"),
            );
          }

          // Extract user documents
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, userIndex) {
              final user = users[userIndex];
              final userData = user.data() as Map<String, dynamic>;

              // Extract user details
              final userName = userData['name'] ?? 'Unknown User';
              final bio = userData['bio'] ?? 'No bio available';
              final followerCount = userData['follower'] ?? 0;
              final followingCount = userData['following'] ?? 0;

              // Safely access the post array
              final posts = userData['post'] is List
                  ? userData['post'] as List<dynamic>
                  : [];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.cyanAccent.shade100,
                            child: Text(
                              userName[0].toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(bio),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Followers: $followerCount"),
                          Text("Following: $followingCount"),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Posts:",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      posts.isNotEmpty
                          ? ListView.builder(
                        itemCount: posts.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, postIndex) {
                          final post = posts[postIndex] as Map<String, dynamic>;
                          final postContent = post['posts'] ?? 'No Content';
                          final likes = post['like'] ?? 0;
                          final dislikes = post['dislike'] ?? 0;
                          final update =
                              post['update'] ?? 'No update timestamp';

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postContent,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Last Update: $update",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Increment likes logic
                                            },
                                            icon: Icon(Icons.thumb_up,
                                                color: Colors.red),
                                          ),
                                          Text("Likes: $likes"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Increment dislikes logic
                                            },
                                            icon: Icon(Icons.thumb_down,
                                                color: Colors.blue),
                                          ),
                                          Text("Dislikes: $dislikes"),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : Text(
                        "No posts available",
                        style:
                        TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
