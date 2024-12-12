import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:get/get.dart';

class   TaskSearchWidget extends StatelessWidget {
  final tasksearchNameController = TextEditingController();
  final RxList<Map<String, String>> tasks = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> storelist = <Map<String, String>>[].obs;
  final RxBool isshow = false.obs;

  Widget functionality(Map<String, String> store, int index) {
    // Define your custom functionality here
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: tasksearchNameController,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  if (tasks.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No Task')),
                    );
                  } else if (tasksearchNameController.text.isEmpty) {
                    tasks.assignAll(storelist);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search field is empty')),
                    );
                  } else {
                    final searchResults = tasks.where((element) {
                      final lowerCaseElement =
                      (element['name'] ?? '').toLowerCase();
                      final lowerCaseElementdescription =
                      (element['description'] ?? '').toLowerCase();
                      final lowerCaseSearchTerm =
                      tasksearchNameController.text.toLowerCase();
                      return lowerCaseElement.contains(lowerCaseSearchTerm) ||
                          lowerCaseElementdescription
                              .contains(lowerCaseSearchTerm);
                    }).toList();

                    if (searchResults.isEmpty) {
                      tasks.assignAll(storelist);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No tasks match your search')),
                      );
                    } else {
                      tasks.assignAll(searchResults);
                    }
                  }
                },
                child: const Icon(Icons.search, color: Colors.green),
              ),
              hintText: "Search Your Task",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            return tasks.isEmpty
                ? const Center(child: Text("No Tasks"))
                : ListView.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var indexstore = index + 1;
                var store = tasks[index];

                // Highlighted text configuration
                final String searchText =
                tasksearchNameController.text.toLowerCase();
                final Map<String, HighlightedWord> highlightWords = {
                  searchText: HighlightedWord(
                    onTap: () {},
                    textStyle: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                };

                return Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        ListTile(
                          leading: Text(
                            indexstore.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: TextHighlight(
                            text: store["name"] ?? "No Name",
                            words: highlightWords,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          subtitle: TextHighlight(
                            text: store["description"] ?? "No Description",
                            words: highlightWords,
                            textStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              isshow.value = !isshow.value;
                            },
                            icon: const Icon(Icons.more_vert,
                                color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Created Date",
                              style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              store["dateandtime"] ?? "No Date",
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          return Offstage(
                            offstage: isshow.value,
                            child: SingleChildScrollView(
                              child: functionality(store, index),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 5,
                  color: const Color(0xFFB6FFF0),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
