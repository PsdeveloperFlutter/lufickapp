//Practice of RiverPod StateProvider
import'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
void main(){
runApp(ProviderScope(child: MaterialApp(home: Riverpod2())));
}
final value=StateProvider<int>((ref){
  return 100;
});

class Riverpod2 extends ConsumerWidget {
  const Riverpod2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer(builder: (context, ref, child) => Center(
            child: Text("${ref.watch(value)}", style: TextStyle(fontSize: 30)),
          )),
          ElevatedButton(
            onPressed: () {
              ref.read(value.notifier).update((state) => state*2);  
            },
            child: Text("press"),
          )
        ],
      ),
    );
  }
}