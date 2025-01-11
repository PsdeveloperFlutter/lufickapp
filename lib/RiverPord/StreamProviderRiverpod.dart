import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//It is the Example of the Stream Provider and make sure it will send the data to the widget every time
final valuestore=StreamProvider<dynamic>((ref)async*{


  for(int i=0;i<5;i++){
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
});



void main(){
  return runApp(ProviderScope(child: MaterialApp(home: homepage())));
}


class homepage extends ConsumerWidget{
  Widget build(BuildContext context, WidgetRef ref) {
    final value=ref.watch(valuestore);
    return Scaffold(
      body: Center(child: value.when(data: (data) {
        return Text(data.toString());
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return CircularProgressIndicator();
      })),
    );
  }
}