//I done this practice in my code

import'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//In this code I create a class which fetch the sateNotifierProvider and I pass two pass Valuenotifer
// which is the StateNotifier class and second parameter is the itemnotifiers class
// which is the state in this code I which I can manage the code in this code I have create the state class and
// set the required parameter in this code and second I create the copywith method in this code and set this class to
// the statenotifer parameter and make sure  super code Will be passed in this code and
// super code set the parent class object an initialized and set the
// function which is name is feddata and set the data through it and set the copywith method and
// set this code to run

void main(){
  runApp(ProviderScope(child: MaterialApp(home:Home(),)));
}
final value=StateNotifierProvider<valuenotifer, itemnotifiers>((ref){ //It contain two parameter stateNotifier and state
  return valuenotifer();
});

class valuenotifer extends StateNotifier<itemnotifiers>{

  valuenotifer():super(itemnotifiers(searchvalue: "Priyanshu Satija"));

  void feddata(String value){
    state=state.copywith(searchvalue: value);
  }

}


class itemnotifiers {
  String searchvalue;
  itemnotifiers({
    required this.searchvalue
});
  itemnotifiers copywith({
    String? searchvalue}){
     return itemnotifiers(searchvalue: searchvalue?? this.searchvalue);

  }
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final data=ref.watch(value);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Consumer(builder: (context,ref,child){
              return Text(ref.watch(value.select((state) => state.searchvalue)));
                   }),

            TextField(
              onChanged: (values){
                ref.read(value.notifier).feddata(values);
              },
            )
          ],
        ),
      ),
    );
  }
}

