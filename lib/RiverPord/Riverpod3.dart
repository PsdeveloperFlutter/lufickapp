//Multiple State Provider in Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';


//State Providers which give us the value and return value every time
final value4=StateProvider<Appstate>((ref){
  return Appstate(slider: 0.5,showpassword:false);
});





final value3=StateProvider<dynamic>((ref){
  return 0.0;
});

class river_pod extends ConsumerWidget {
  const river_pod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final slider=ref.watch(value4);

    return Scaffold(
      appBar: AppBar(
        title: Text("river_pod"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

        
            Consumer(builder: (context, ref, child){
              return
        
                Center(
                child: Container(
                  width: 300,
                  height: 300,
                  color: Colors.blue.shade700.withOpacity(ref.watch(value4.select((state) => state.slider))),
                ),
              );
        
            }),
        
            Consumer(builder: (context, ref, child){
              return
        
                Slider(value: slider.slider, onChanged: (value)
                {ref.read(value4.notifier).update((state) => state.copywith(slider: value));},);
        
            }),
            Consumer(builder: (context,ref,child){return
              IconButton(onPressed: (){
                ref.read(value4.notifier).update((state) => state.copywith(showpassword: !ref.watch(value4.select((state) => state.showpassword))));
              }, icon: Icon(ref.watch(value4.select((state) => state.showpassword)) ? Icons.visibility : Icons.visibility_off));

            }),

           ],
        ),
      ),
    );
  }
}
void main() {
  runApp(ProviderScope(child: MaterialApp(home: river_pod())));
}



class Appstate{
  final double slider;
  final bool showpassword;
  Appstate({required this.slider,required this.showpassword});


  Appstate copywith({double? slider, bool? showpassword}) {
    return Appstate(slider: slider ?? this.slider, showpassword: showpassword ?? this.showpassword);
  }
}