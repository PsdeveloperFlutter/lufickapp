import'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class givemeint extends AsyncNotifier<int>{


  @override
  Future<int>build()async{
    await Future.delayed(Duration(seconds: 10));
    return 0;
  }
  Future<int>increment()async{
    state=const AsyncValue.loading();
    await Future.delayed(Duration(seconds: 10));
    state=AsyncValue.data(state.value!+1);
    return state.value??0;
  }


}

List<String>ps=[
  "hello",
  "world",
  "priyanshu",
  "satija"
];
final valuestore=AsyncNotifierProvider<givemeint,int>(givemeint.new);


class Screen extends ConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref){
    final data=ref.watch(valuestore);
    final changes=ref.read(valuestore.notifier);
    return Scaffold(
      body: data.when(data: (datas) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(ps[datas].toString()),
              SizedBox(height: 12,),
              ElevatedButton(onPressed: ()async{
                await changes.increment();
              }, child: Text("Increment"))
            ],
          ),
        );
      }, error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}



void main(){
  runApp(ProviderScope(child: MaterialApp(home: Screen())));
}