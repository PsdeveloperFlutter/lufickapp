import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//This is for the Itemvalues and make sure we set this
class itemvalues{
  final int id;
   String name;
   bool favourite;

  itemvalues({required this.id,required this.name,required this.favourite});

  itemvalues copywith({int? id,String? name,bool? favourite}){
    return itemvalues(
      id: id??this.id,
      name: name??this.name,
      favourite: favourite??this.favourite
    );
  }
}

dynamic commandvalues=StateNotifierProvider<FavouritestateNotifier, Favouritestate>((ref){
  return FavouritestateNotifier();
});

class FavouritestateNotifier extends StateNotifier<Favouritestate> {

   FavouritestateNotifier():super(Favouritestate(items: [], fillereditems: []));

   void addvalue(){
     List<itemvalues> items=[
       itemvalues(id: 1, name: "Macbook", favourite: true),
       itemvalues(id: 2, name: "iPhone", favourite: true),
       itemvalues(id: 3, name: "iPad", favourite: false),
       itemvalues(id: 4, name: "Watch", favourite: true),
       itemvalues(id: 5, name: "AirPods", favourite: false),
     ];
     state=state.copyWith(items: items,fillereditems: items);
   }

   //For set the Icon and make sure that Icon will be changed
   void iconset(int index){
     List<itemvalues>updateitems=state.items.toList();
     updateitems[index].favourite=!updateitems[index].favourite;
     state=state.copyWith(items: updateitems,fillereditems: updateitems);
   }
   //This Icon is set for update of data
   void updatedat(int index,String name){
     List<itemvalues>updateitems=state.items.toList();
     updateitems[index].name=name;
     state=state.copyWith(items: updateitems,fillereditems: updateitems);
   }
    //This is for delete operation in flutter
   void delete(int index){
     List<itemvalues>updateitems=state.items.toList();
     updateitems.removeAt(index);
     state=state.copyWith(items: updateitems,fillereditems: updateitems);
   }
   void searching(String query){
     List<itemvalues>filtereditems=state.items.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
     state=state.copyWith(fillereditems: filtereditems);
   }

}

class Favouritestate {
  final List<itemvalues> items;
  final List<itemvalues> fillereditems ;
  Favouritestate({required this.items,required this.fillereditems});


  Favouritestate copyWith({List<itemvalues>? items,List<itemvalues>? fillereditems}) {
    return Favouritestate(items: items??this.items,fillereditems: fillereditems??this.fillereditems);
  }

}


TextEditingController controllerss=TextEditingController();

class UIs extends ConsumerWidget {
  const UIs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hello=ref.watch(commandvalues);
    return Scaffold(
      appBar: AppBar(
        title: Text("river_pod"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value){
            //    ref.read(commandvalues.notifier).updatedat(,value);();

            },
            decoration: InputDecoration(
              hintText: "Enter the text",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
              controller: controllerss,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: hello.fillereditems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitle: IconButton(onPressed: (){
                    ref.read(commandvalues.notifier).delete(index);
                  }, icon: Icon(Icons.delete)),
                  leading:IconButton(onPressed: (){
                    ref.read(commandvalues.notifier).updatedat(index,controllerss.text.toString());
                  }, icon: Icon(Icons.update,color: Colors.blue,)),
                  title: Text(hello.fillereditems[index].name),
                  trailing: IconButton(onPressed: (){
                   ref.read(commandvalues.notifier).iconset(index);
                  }, icon: Icon(hello.fillereditems[index].favourite?Icons.favorite:Icons.favorite_border)),
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){
          ref.read(commandvalues.notifier).addvalue();
        },child: Icon(Icons.add,color: Colors.white,),),
    );
  }
}


void main(){
  runApp(ProviderScope(child: MaterialApp(home: UIs(),)));
}