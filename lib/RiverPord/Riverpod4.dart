//State Notifier in Riverpod and Consumer Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//state Notifier Providers in Riverpod

final searchprovider=StateNotifierProvider<searchnotifers,searchstate>((ref){
  return searchnotifers();
});

class searchnotifers extends StateNotifier<searchstate>{
  searchnotifers() : super(searchstate(search: "",count: 0));
  void search(String query){
    state=state.copywith(search: query);
  }
  void setcount(dynamic counts){
    state=state.copywith(count: counts);
  }
}


class searchstate{
  final  String search;
  final int count;
  searchstate({required this.search,required this.count});

  searchstate copywith({String? search,int? count}){
    return searchstate(search: search ?? this.search, count: count ?? 0);
  }

}


class rivers extends ConsumerWidget {
  const rivers({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      body:Column(
        children: [
          Center(
            child: Text("hello",style: TextStyle(fontSize: 30),),
          ),
          TextField(
            onChanged: (value){
              ref.read(searchprovider.notifier).search(value);
            },
          ),
          Consumer(builder: (context,ref,child){
            return
              Text(ref.watch(searchprovider.select((state) => state.search)),style: TextStyle(fontSize: 30),);
          })
          ,

          SizedBox(height: 12,),
          TextField(
              onChanged: (value){
                ref.read(searchprovider.notifier).setcount(int.parse(value));
              }),

          Consumer(builder: (context,ref,child){
            return
              Text(ref.watch(searchprovider.select((state) => state.count.toString())),style: TextStyle(fontSize: 30),);
          })


        ],
      ),
    );
  }
}

void main(){
  runApp(ProviderScope(child: MaterialApp(home: rivers())));
}