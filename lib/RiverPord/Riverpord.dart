import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

//Single provider which give us the const value and return const value every time
final hello = Provider<String>((ref){
  return "hello";
});

final age = Provider<int>((ref){
  return 100;
});

void main() {
  runApp(
    ProviderScope(

      child: MaterialApp(
        home:river_pod(),
      ),
    )
  );
}
/*class river_pod extends ConsumerWidget {
  const river_pod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hellos=ref.watch(hello);
    final temp=ref.watch(age);
    return Scaffold(
      appBar: AppBar(
        title: Text("river_pod"),
      ),
      body: Center(
        child: Text("$hellos $temp",style: TextStyle(fontSize: 30),),
      ),
    );
  }
}*/


class river_pod extends ConsumerStatefulWidget {
  const river_pod({super.key});

  @override
  ConsumerState<river_pod> createState() => _river_podState();
}

class _river_podState extends ConsumerState<river_pod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("river_pod"),
      ),
      body: Center(
      child: Column(
        children: [
          Text(ref.watch(hello),style: TextStyle(fontSize: 30),),

          Text(ref.watch(age).toString(),style: TextStyle(fontSize: 30),),

        ],
      ),
      )
    );
  }
}
