import'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String>fetchdata(String id)async{
  await Future.delayed(Duration(seconds: 10));
  return id;
}
//This fetch the initial value will be  zero.
final fetchvalue=FutureProvider.family<String,String>(((ref,id)=>fetchdata(id)));


void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final hellos = ref.watch(fetchvalue("Priyanshu"));
              return
              hellos.when(data: (value) => Text(value),
                  error: (error, stack) => Text(error.toString()),
                  loading: () => Center(child: CircularProgressIndicator(),));

            },
          ),
        ),
      ),
    );
  }
}