import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class  friendlist extends StatefulWidget {
  @override
  State<friendlist> createState() => _friendlistState();
}

class _friendlistState extends State<friendlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade500,
        title: const Text(
          "Add Friend",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 50,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Assume the current user's email is available
            final currentUserEmail = 'currentuser@example.com'; // Replace with actual current user's email

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var user = snapshot.data!.docs[index];
                  final isCurrentUser = user.id == currentUserEmail;

                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Profile Section
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 26,
                                  child: Text(
                                    user['name']
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: Colors.deepPurple.shade50,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                user['name'].toString().toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          // Followers and Following
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                user['follower'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(width: 17),
                          Column(
                            children: [
                              Text(
                                user['following'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          // Add Button
                          GestureDetector(
                            onTap: isCurrentUser
                                ? null
                                : () async {
                              try {
                                // Update current user's "following"
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUserEmail)
                                    .update({
                                  'following': FieldValue.increment(1),
                                });

                                // Update selected user's "follower"
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.id)
                                    .update({
                                  'follower': FieldValue.increment(1),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "You followed ${user['name']}!"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Error updating fields: $e"),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.grey.shade400
                                    : Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: isCurrentUser
                                        ? Colors.grey
                                        : Colors.deepPurple,
                                    width: 1),
                              ),
                              child: Icon(
                                Icons.add,
                                color: isCurrentUser
                                    ? Colors.grey
                                    : Colors.deepPurple,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade500,
              ),
            );
          }
        },
      ),
    );
  }
}
