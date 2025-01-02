import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';


//Single Riverpod

final value=Provider<String>((ref){
  return "Priyanshu Satija";
});
class rivers extends ConsumerWidget {


  @override
  Widget build(BuildContext context,WidgetRef ref) {
     final hellos=ref.watch(value);
    return  Scaffold(
      body: Center(
        child: Text("$hellos",style: TextStyle(fontSize: 30),),
      ),

    );
  }
}

final value1=Provider<int>((ref){
  return 100;
});

class riverstatess extends ConsumerStatefulWidget {
  
  @override
  ConsumerState<riverstatess> createState() => _riverstatessState();
}

class _riverstatessState extends ConsumerState<riverstatess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(ref.watch(value1).toString(),style: TextStyle(fontSize: 30),),
    );
  }
}

void main(){
  runApp(
    ProviderScope(child: MaterialApp(home: riverstatess(),))
  );
}