import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 1: Define the StateNotifier class
/// -----------------------------------------
/// A StateNotifier is used to manage the state and logic for a specific functionality.
/// In this case, it manages user-specific data.
class UserNotifier extends StateNotifier<String> {
  /// The constructor accepts a userId parameter to initialize the state.
  UserNotifier(String userId) : super("Initializing data for user: $userId");

  /// Method to simulate fetching user data from an API or database.
  /// The `state` variable is updated once the data is fetched.
  Future<void> fetchUserData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay (e.g., network call)
    state = "Fetched user data for userId: $state";
  }
}

/// Step 2: Create a StateNotifierProvider.family
/// ----------------------------------------------
/// `StateNotifierProvider.family` allows us to dynamically create providers
/// based on a parameter. In this case, we pass a `userId` to manage user-specific state.
final userProvider = StateNotifierProvider.family<UserNotifier, String, String>(
      (ref, userId) => UserNotifier(userId),
);

/// Step 3: Create the UI to interact with the provider
/// ----------------------------------------------------
/// Use the provider dynamically to display user-specific data and perform actions.
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example: User ID passed dynamically (this can come from a list, input, etc.)
    final userId = "user123";

    /// Watch the dynamic provider instance for the given userId.
    /// This will automatically rebuild the widget when the state changes.
    final userState = ref.watch(userProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text("StateNotifier.family Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Display the current state for the specific userId.
            Text(
              userState,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            /// Button to trigger the fetchUserData() method of the UserNotifier.
            /// Use `ref.read` to access the notifier instance.
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider(userId).notifier).fetchUserData();
              },
              child: Text("Fetch User Data"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 4: Main entry point
/// -------------------------
/// Wrap the app in a ProviderScope to enable Riverpod state management.
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/*
Explanation in Comments
StateNotifier Class

Manages the state and logic for specific functionality.
UserNotifier initializes with a userId and provides methods like fetchUserData to update the state.
StateNotifierProvider.family

Allows dynamic creation of providers based on a parameter (userId in this case).
Creates unique state instances for each userId.
ConsumerWidget

Watches the dynamic provider instance using ref.watch(userProvider(userId)).
Triggers actions by accessing the notifier via ref.read.
UI Updates

The widget rebuilds automatically when the state changes.
How It Works
When the app starts, UserNotifier initializes with user123 as the userId.
The current state (Initializing data for user: user123) is displayed.
Pressing the "Fetch User Data" button calls fetchUserData(), simulating an API call.
Once data is fetched, the state updates (Fetched user data for userId: user123), and the UI rebuilds automatically to reflect the new state.
Output Example
Initial State:
"Initializing data for user: user123"

After Button Click:
"Fetched user data for userId: user123"

Advantages Demonstrated
Dynamic Behavior: Unique state for each userId.
Encapsulation: Logic (e.g., fetching user data) is encapsulated in UserNotifier.
Reusability: The same provider can be used for multiple user IDs.
Automatic Updates: UI rebuilds when state changes.
This approach showcases how StateNotifier.family makes managing dynamic and complex state in Flutter apps clean, modular, and scalable.
 */