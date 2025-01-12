import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Step 1: Create a ChangeNotifier class
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Notify listeners about the change
  }
}

// Step 2: Create a ChangeNotifierProvider
final counterProvider = ChangeNotifierProvider<Counter>((ref) => Counter());

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider); // Watch the ChangeNotifier

    return Scaffold(
      appBar: AppBar(title: Text("ChangeNotifierProvider Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Count: ${counter.count}"), // Access the count
            ElevatedButton(
              onPressed: () => counter.increment(), // Call the increment method
              child: Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}


/*
Explanation of ChangeNotifierProvider in Riverpod
What is ChangeNotifierProvider?
The ChangeNotifierProvider in Riverpod is a type of provider used to manage state with a ChangeNotifier. A ChangeNotifier is a class provided by Flutter that allows you to:

Hold state.
Notify listeners when the state changes.
ChangeNotifierProvider makes it easy to integrate this state management approach into the Riverpod framework.

When to Use ChangeNotifierProvider?
You’re already familiar with or using Flutter’s ChangeNotifier for state management.
Your app’s state can be efficiently represented by a single class managing both the state and logic.
You want a centralized way to manage state changes and trigger UI updates when the state changes.
Key Features
State Encapsulation

All logic and state are encapsulated inside a ChangeNotifier class.
Automatic State Updates

UI automatically rebuilds when the state changes, as long as it listens to the ChangeNotifier.
Easy Migration

If you’re migrating from ChangeNotifier-based state management (like Provider), this is an easy transition.
How Does It Work?
Create a ChangeNotifier Class

This class holds the state and exposes methods to update it.
Use notifyListeners() to inform listeners when the state changes.
Create a ChangeNotifierProvider

Use ChangeNotifierProvider to make your ChangeNotifier instance available to the widget tree.
Consume the Provider

Use ref.watch to read the state.
Use ref.read to call methods from the ChangeNotifier.



*/