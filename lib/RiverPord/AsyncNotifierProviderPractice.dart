import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lufickapp/RiverPord/FutureProviderPractice.dart';

void main(){
  runApp(ProviderScope(child: MaterialApp(
    home: screens(),
  )));
}

//step 1 create a class which fetch the AsyncNotifierProvider
class countvalue extends AsyncNotifier<int>{

  @override
  Future<int>build()async{
    await Future.delayed(Duration(seconds: 10));
    return 0;
  }

  Future<void>incerement()async{
    state=const AsyncValue.loading();
    await Future.delayed(Duration(seconds: 10));
    state=AsyncValue.data(state.value!+1); //! This indicate that value should be null able
  }

}

final countvalueProvider=AsyncNotifierProvider<countvalue,int>(countvalue.new);


class screens extends ConsumerWidget {
  const screens({super.key});

  Widget build(BuildContext context,WidgetRef ref){
    final data=ref.watch(countvalueProvider);
    final changes=ref.read(countvalueProvider.notifier);
    return Scaffold(
      body: data.when(data: (datas) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(datas.toString()),
              SizedBox(height: 12,),
              ElevatedButton(onPressed: ()async{
                await changes.incerement();
              }, child: Text("Increment"))
            ],
          ),
        );
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return CircularProgressIndicator();
      })
    );
  }

}










//This code of the Future Provider


final value =FutureProvider((ref){
  return Future.delayed(Duration(seconds: 10),()=>"Priyanshu satija");
});

class homepage extends ConsumerWidget {
  const homepage({super.key});
Widget build(BuildContext context,WidgetRef ref){
    final values=ref.watch(value);
    return Scaffold(
      body: Center(child: values.when(data: (data) {
        return Text(data);
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return CircularProgressIndicator();
      })),
    );
  }
}