import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main(){
  runApp(ProviderScope(child: MaterialApp(home: HomePage())));
}

final values=Provider.family<String,String>((ref,userId){
  return "Hello $userId";
});


class HomePage extends ConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Provider.family Example"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(builder: (context,ref,_){
            final userData=ref.watch(values("Priyanshu"));
            return Text(userData);
          })
        ],
      ),
    );
  }
}
