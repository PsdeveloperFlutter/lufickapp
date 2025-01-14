import'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<int> v_use=[1,2,3];

//This fetch the initial value will be  zero.
final fetchvalue=StateProvider.family<int,int>((ref,id)=>0);


class StateFamilyProviderd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: ListView.builder(itemBuilder: (context,index)
      {
        return Consumer(builder: (context, ref, _) {
          final value = ref.watch(fetchvalue(index));
          return ListTile(
            subtitle: Text("Specific Value "+index.toString()),
            title: Text("Value will be update"+value.toString()),
            trailing: IconButton(onPressed: () {
              ref.read(fetchvalue(index).notifier).state++;
            }, icon: Icon(Icons.add)),);
        });
      },itemCount: v_use.length,),
    ),);
  }
}