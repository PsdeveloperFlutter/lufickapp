import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

TextEditingController commentController = TextEditingController();

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: Text(
          'Posts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(bio),
                              ],
                            )
                          ],
                        ),
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
                                final post =
                                    posts[postIndex] as Map<String, dynamic>;
                                final postContent =
                                    post['posts'] ?? 'No Content';
                                final likes = post['like'] ?? 0;
                                final postsetting = post['postsetting'] ?? 0;
                                final dislikes = post['Dislikes'] ?? 0;
                                final createdpostdate = post['CreateDate'];
                                final update =
                                    post['update'] ?? 'No update timestamp';
                                final Comments = post['Comments'];

                                //This Identify the post is public or private
                                if (postsetting == 0) {
                                  return Card(
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            postContent,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "Created At: ${formatTimestamp(createdpostdate)}",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),

                                          SizedBox(height: 12),
                                          Text(
                                            "Last Update: ${formatTimestamp(update)}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        // Cast user data to Map<String, dynamic>
                                                        final userData =
                                                            user.data() as Map<
                                                                String,
                                                                dynamic>;

                                                        // Get the specific post from the user's posts array
                                                        final post =
                                                            posts[postIndex]
                                                                as Map<String,
                                                                    dynamic>;

                                                        // Prepare the updated post data
                                                        final updatedPost = {
                                                          ...post,
                                                          'like': (post[
                                                                      'like'] ??
                                                                  0) +
                                                              1, // Increment the likes
                                                          'update': DateTime
                                                              .now(), // Update timestamp
                                                        };

                                                        // Remove the old post from Firestore
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user
                                                                .id) // Use user.id instead of accessing email directly
                                                            .update({
                                                          'post': FieldValue
                                                              .arrayRemove(
                                                                  [post]),
                                                        });

                                                        // Add the updated post back to Firestore
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.id)
                                                            .update({
                                                          'post': FieldValue
                                                              .arrayUnion([
                                                            updatedPost
                                                          ]),
                                                        });

                                                        print(
                                                            "Post updated successfully for user ${userData['email']}");
                                                      } catch (e) {
                                                        // Handle and log errors
                                                        print(
                                                            "Error updating likes: $e");
                                                      }
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
                                                    onPressed: () async {
                                                      try {
                                                        // Cast user data to Map<String, dynamic>
                                                        final userData =
                                                            user.data() as Map<
                                                                String,
                                                                dynamic>;

                                                        // Get the specific post from the user's posts array
                                                        final post =
                                                            posts[postIndex]
                                                                as Map<String,
                                                                    dynamic>;

                                                        // Prepare the updated post data
                                                        final updatedPost = {
                                                          ...post,
                                                          'Dislikes': (post[
                                                                      'Dislikes'] ??
                                                                  0) +
                                                              1, // Increment the likes
                                                          'update': DateTime
                                                              .now(), // Update timestamp
                                                        };

                                                        // Remove the old post from Firestore
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user
                                                                .id) // Use user.id instead of accessing email directly
                                                            .update({
                                                          'post': FieldValue
                                                              .arrayRemove(
                                                                  [post]),
                                                        });

                                                        // Add the updated post back to Firestore
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.id)
                                                            .update({
                                                          'post': FieldValue
                                                              .arrayUnion([
                                                            updatedPost
                                                          ]),
                                                        });

                                                        print(
                                                            "Post updated successfully for user ${userData['email']}");
                                                      } catch (e) {
                                                        // Handle and log errors
                                                        print(
                                                            "Error updating likes: $e");
                                                      }
                                                    },
                                                    icon: Icon(Icons.thumb_down,
                                                        color: Colors.blue),
                                                  ),
                                                  Text("Dislikes: $dislikes"),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          //This is fetch the comments on specific post
                                          ExpansionTile(
                                            title: Text("Comments"),
                                            children: [
                                              Comments.length == 0
                                                  ? Text("No comments")
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index ==
                                                            Comments.length) {
                                                          return Text(
                                                              "No more comments");
                                                        } else {
                                                          return Card(
                                                            elevation: 5,
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(8),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade700),
                                                                color: Colors
                                                                    .grey[200],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    Comments[
                                                                            index]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      itemCount:
                                                          Comments.length,
                                                    ),
                                              SizedBox(height: 12),
                                              TextField(
                                                controller: commentController,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      String newComment =
                                                          commentController.text
                                                              .toString()
                                                              .trim();

                                                      if (newComment
                                                          .isNotEmpty) {
                                                        try {
                                                          // Assuming `docs`, `index`, and Firestore collection are pre-defined
                                                          final post = users[0]
                                                                  ['post']
                                                              [postIndex];
                                                          final updatedComments =
                                                              List<String>.from(
                                                                  post['Comments'] ??
                                                                      []);
                                                          updatedComments
                                                              .add(newComment);

                                                          // Update Firestore with the new comment
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(users[0]
                                                                  ['email'])
                                                              .update({
                                                            "post": FieldValue
                                                                .arrayRemove(
                                                                    [post]),
                                                          });

                                                          final updatedPost = {
                                                            ...post,
                                                            "Comments":
                                                                updatedComments,
                                                          };

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(users[0]
                                                                  ['email'])
                                                              .update({
                                                            "post": FieldValue
                                                                .arrayUnion([
                                                              updatedPost
                                                            ]),
                                                          });

                                                          commentController
                                                              .clear();
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    "Error adding comment: $e")),
                                                          );
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  "Comment cannot be empty!")),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.send,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Comment',
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : Center(
                              child: Text(
                                "No posts available",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
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

// Helper function to format the timestamp
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd-MM-yyyy HH:mm')
          .format(dateTime); // Example format: 20-12-2024 15:30
    } else if (timestamp is DateTime) {
      return DateFormat('dd-MM-yyyy HH:mm').format(timestamp);
    } else {
      return "Invalid date";
    }
  }
}
