import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lufickapp/RiverPord/TodoListRiverPod.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp(home: Home())));
}

// Class Item
class Item {
  int id;
  String name;
  bool favourite = false;
  Item({required this.id, required this.name, required this.favourite});

  Item copyWith({
    int? id,
    String? name,
    bool? favourite,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      favourite: favourite ?? this.favourite,
    );
  }
}

// Favourite State
class Favouritestate {
  final List<Item> allitems;
  final List<Item> fillereditems;
  final String search;

  Favouritestate({
    required this.allitems,
    required this.fillereditems,
    required this.search,
  });

  Favouritestate copywith({
    List<Item>? allitems,
    List<Item>? fillereditems,
    String? search,
  }) {
    return Favouritestate(
      allitems: allitems ?? this.allitems,
      fillereditems: fillereditems ?? this.fillereditems,
      search: search ?? this.search,
    );
  }
}

// State Notifier Providers state Notifier
final valueofstate =
StateNotifierProvider<FavouritestateNotifier, Favouritestate>((ref) {
  return FavouritestateNotifier();
});

class FavouritestateNotifier extends StateNotifier<Favouritestate> {
  FavouritestateNotifier()
      : super(Favouritestate(allitems: [], fillereditems: [], search: ""));

  void additem() {
    List<Item> item = [
      Item(id: 1, name: "Macbook", favourite: true),
      Item(id: 2, name: "iPhone", favourite: true),
      Item(id: 3, name: "iPad", favourite: false),
      Item(id: 4, name: "Watch", favourite: true),
      Item(id: 5, name: "AirPods", favourite: false),
    ];
    state = state.copywith(allitems: item, fillereditems: item);
  }

  // Search query
  void search(String query) {
    List<Item> filtereditems = state.allitems
        .where((element) =>
        element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = state.copywith(fillereditems: filtereditems, search: query);
  }

  // Toggle favourite status
  void toggleFavourite(int index) {
    List<Item> updatedItems = state.allitems.toList();
    updatedItems[index] =
        updatedItems[index].copyWith(favourite: !updatedItems[index].favourite);
    state = state.copywith(allitems: updatedItems, fillereditems: updatedItems);
  }

  void removefun(int index){
    List<Item>updateditems=state.allitems.toList();
    updateditems.removeAt(index);
    state=state.copywith(allitems: updateditems,fillereditems: updateditems);
  }

  void setnewItem(){
    List<Item>updateditems=state.allitems.toList();
    updateditems.add(Item(id: 6, name: "AirPods", favourite: false));
    state=state.copywith(allitems: updateditems,fillereditems:updateditems );
  }

  void update(int index, String name) {
    List<Item> updateditems = state.allitems.toList();
    updateditems.insert(index, Item(id: state.allitems[index].id, name: name, favourite: state.allitems[index].favourite));
    state = state.copywith(
      allitems: updateditems,
      fillereditems: updateditems,
    );
  }
}

TextEditingController controllerss=TextEditingController();
// Home Screen UI
class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(valueofstate).fillereditems;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controllerss,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search...",
                ),
                onChanged: (value) {
                  ref.read(valueofstate.notifier).search(value);
                },
              ),
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(child: Text("No Data Found")),
              )
            else
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(onPressed: (){
                        ref.read(valueofstate.notifier).update(index, controllerss.text.toString().trim());
                      }, icon: Icon(Icons.update)),
                      title: Text(items[index].name),
                      subtitle: IconButton(onPressed: (){
                        ref.read(valueofstate.notifier).removefun(index);
                      }, icon: Icon(Icons.delete)),
                      trailing: IconButton(
                        onPressed: () {
                          ref.read(valueofstate.notifier).toggleFavourite(index);
                        },
                        icon: Icon(
                          items[index].favourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: items[index].favourite ? Colors.red : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: SingleChildScrollView(
       scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              onPressed: () {
                ref.read(valueofstate.notifier).additem();
              },
              child: Icon(Icons.add, color: Colors.white),
            ),

            SizedBox(width: 12,),

            FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              onPressed: () {
               ref.read(valueofstate.notifier).setnewItem();
              },
              child: Icon(Icons.new_label, color: Colors.white),
            ),

            SizedBox(width: 12,),
            FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              onPressed: () {
                ref.read(valueofstate.notifier).setnewItem();
              },
              child: Icon(Icons.update, color: Colors.white),
            ),


          ],
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
