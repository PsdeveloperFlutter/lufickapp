import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Item {
  String id;
  String name;
  Item({required this.id, required this.name});
}

final itemprovider = StateNotifierProvider<itemnotifer, List<Item>>((ref) {
  return itemnotifer();
});

class itemnotifer extends StateNotifier<List<Item>> {
  itemnotifer() : super([]);


  void addItem(String name) {
    final item = Item(id: DateTime.now().toString(), name: name);
    state.add(item);
  }

  void deleteitem(Item id) {
    state.removeWhere((item) => item.id == id);
  }


}

TextEditingController controllers = TextEditingController();

class screenoflist extends ConsumerWidget {
  const screenoflist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(itemprovider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(value[index].name),
                  subtitle: Text(value[index].id),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllers,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Name",
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (controllers.text.isNotEmpty) {
                ref.read(itemprovider.notifier)
                    .addItem(controllers.text);
                controllers.clear();
              } else {
                print("Please enter a Todo item");
              }
            },
            child: Text("Press"),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: screenoflist(),
      ),
    ),
  );
}