//RiverPod StateProvider 

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';


//State Providers which give us the value and return value every time
final value1=StateProvider<dynamic>((ref){
  return 100;
});

final switchs=StateProvider<bool>((ref){
  return false;
});

class riverpods extends ConsumerStatefulWidget {
  const riverpods({super.key});

  @override
  ConsumerState<riverpods> createState() => _riverpodsState();
}

class _riverpodsState extends ConsumerState<riverpods> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer(builder: (context,ref,child){
                print("build2");
              return  Text(ref.watch(value1).toString(),style: TextStyle(fontSize: 30),);
              }),

              Consumer(builder: (context,ref,child){
                print("build3");
                return Switch(value:ref.watch(switchs as ProviderListenable<bool>) , onChanged: (value){
             ref.read(switchs.notifier).update((state) => value);
                 });
              }),

              TextButton(onPressed: (){
                ref.read(value1.notifier).update((state) => state+1);
              }, child:Text("Press"))
            ],
          ),
        ),
      );
  }
}
void main(){
  runApp(ProviderScope(child: MaterialApp(home: riverpods())));
}