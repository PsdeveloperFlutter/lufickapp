import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(){
  runApp(ProviderScope(child: MaterialApp(home: screens())));
}
final values=FutureProvider<String>((ref)async{
  await Future.delayed(Duration(seconds: 10));
  return "Priyanshu satija ";
});





class screens extends ConsumerWidget{
  const screens({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final data=ref.watch(values);
    return Scaffold(
      body: data.when(data: (data) {
        return Text(data.toString());
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return CircularProgressIndicator();
      })
    );
  }
}