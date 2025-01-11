import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final values = FutureProvider<String>((ref) async {
 await Future.delayed(Duration(seconds: 10));
 return "Priyanshu satija";
});
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncvalues = ref.watch(values);

    return MaterialApp(
      home: Scaffold(
        body: asyncvalues.when(
            data: (value) => Center(child: Text("$value")),
            error: (error, stack) => Text("error"),
            loading: () => CircularProgressIndicator(
                  color: Colors.blue.shade700,
                )),
      ),
    );
  }
}
