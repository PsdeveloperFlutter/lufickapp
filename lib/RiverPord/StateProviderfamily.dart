import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'StateFamilyProviderpractice.dart';

// Define a StateProvider.family for a counter
final counterProvider = StateProvider.family<int, int>((ref, id) => 0);

void main() {
  runApp(ProviderScope(child: StateFamilyProviderd()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example IDs for counters
    final counterIds = [1, 2, 3];

    return Scaffold(
      appBar: AppBar(title: Text("StateProvider.family Example")),
      body: ListView.builder(
        itemCount: counterIds.length,
        itemBuilder: (context, index) {
          final id = counterIds[index];
          final counter = ref.watch(counterProvider(id));

          return ListTile(
            title: Text("Counter ID: $id"),
            subtitle: Text("Value: $counter"),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                ref.read(counterProvider(id).notifier).state++;
              },
            ),
          );
        },
      ),
    );
  }
}
