import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import'FutureRiverpod1.dart';
// Step 1: Create a FutureProvider
final dataProvider = FutureProvider<String>((ref) async {
  // Simulate a delay (e.g., fetching data from an API)
  await Future.delayed(Duration(seconds: 10));
  return "Hello, Riverpod!"; // Return some data
});

void main() {
  runApp(ProviderScope(child: MyApp ()));
}

class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Step 2: Listen to the FutureProvider
    final asyncValue = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text("FutureProvider Example")),
      body: Center(
        child: asyncValue.when(
          // Loading state
          loading: () => CircularProgressIndicator(),
          // Data loaded successfully
          data: (value) => Text(value),
          // Error occurred
          error: (error, stack) => Text("Error: $error"),
        ),
      ),
    );
  }
}
