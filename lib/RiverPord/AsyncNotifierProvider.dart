import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Step 1: Create an AsyncNotifier
class CounterNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    // Initialize the state (e.g., simulate fetching from an API)
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    return 0; // Initial state is 0
  }

  Future<void> increment() async {
    // Update the state asynchronously
    state = const AsyncValue.loading(); // Indicate loading
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    state = AsyncValue.data(state.value! + 1); // Increment the current value
  }
}

// Step 2: Create an AsyncNotifierProvider
final counterProvider = AsyncNotifierProvider<CounterNotifier, int>(CounterNotifier.new);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
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
    // Step 3: Listen to the AsyncNotifierProvider
    final asyncValue = ref.watch(counterProvider);
    final notifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("AsyncNotifierProvider Example")),
      body: Center(
        child: asyncValue.when(
          loading: () => CircularProgressIndicator(),
          data: (value) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Counter: $value"),
              ElevatedButton(
                onPressed: () => notifier.increment(),
                child: Text("Increment"),
              ),
            ],
          ),
          error: (error, stack) => Text("Error: $error"),
        ),
      ),
    );
  }
}
/*
Explanation
AsyncNotifier

A CounterNotifier class is created, extending AsyncNotifier<int>.
The build() method initializes the state asynchronously. In this example:
It waits for 1 second (simulating a data fetch).
Then it returns the initial value of 0.
Updating the State

The increment() method:
Sets the state to loading using state = AsyncValue.loading().
Waits for 1 second (simulating a delay).
Updates the state by incrementing the current value (state = AsyncValue.data(state.value! + 1)).
AsyncNotifierProvider

The counterProvider connects the CounterNotifier to the app.
It manages the state (AsyncValue<int>) and exposes methods like increment().
Consuming the Provider

In ConsumerWidget:
ref.watch(counterProvider) listens to the state changes.
asyncValue.when handles the loading, data, and error states.
ref.read(counterProvider.notifier) gives access to the notifier to call methods like increment().
UI Behavior

Initially, a loading spinner is shown while the state initializes.
Once loaded, it displays the current counter value and an "Increment" button.
Clicking the button triggers the increment() method, showing a loading spinner and updating the counter after 1 second.
Output
Initially, a spinner is shown for 1 second.
The counter (Counter: 0) appears along with an "Increment" button.
Clicking "Increment":
A spinner briefly appears.
The counter updates to the next value (Counter: 1, Counter: 2, etc.).
Key Points
AsyncNotifier: Manages asynchronous state (e.g., loading, data, error).
AsyncNotifierProvider: Connects the notifier to your app.
AsyncValue: Handles different states (loading, data, error) seamlessly.

*/