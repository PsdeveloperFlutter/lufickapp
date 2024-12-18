import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxList<dynamic> imagelist = [
  "assets/images/nature1..jpg",
  "assets/images/nature2.jpg",
  "assets/images/nature3.jpg",
  "assets/images/nature4.jpg",
].obs;

RxList<dynamic> likeanddislike = RxList<int>();
RxList<dynamic> isPostVisible = RxList<bool>();
RxList<dynamic> postTimes = RxList<String>();

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the logic for like/dislike, visibility, and timestamps
    for (var value in imagelist) {
      likeanddislike.add(0);
      isPostVisible.add(true);
      postTimes.add("Posted ${DateTime.now().hour}:${DateTime.now().minute}"); // Example timestamp
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: const Text('Post'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: imagelist.length,
          itemBuilder: (BuildContext context, int index) {
            // Check if the post is visible
            if (!isPostVisible[index]) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Post Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        imagelist[index],
                        width: screenWidth,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Post Timestamp
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            postTimes[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              isPostVisible[index] = false; // Hide the post
                            },
                          ),
                        ],
                      ),
                    ),
                    // Like/Dislike Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              likeanddislike[index] =
                              likeanddislike[index] == 0 ? 1 : 0; // Toggle like state
                            },
                            child: Obx(
                                  () => Icon(
                                likeanddislike[index] == 0
                                    ? Icons.thumb_down
                                    : Icons.thumb_up,
                                color: likeanddislike[index] == 0
                                    ? Colors.blue
                                    : Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                          Text(
                            likeanddislike[index] == 0 ? "Disliked" : "Liked",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: likeanddislike[index] == 0
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
