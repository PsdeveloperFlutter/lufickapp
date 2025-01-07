import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final valueChangesProvider = ChangeNotifierProvider<Satija>((ref) {
  return Satija();
});

class Satija extends ChangeNotifier {
  List<String> _data = [];

  List<String> get data => _data;

  void addData(String value) {
    if (value.isNotEmpty) {
      _data.add(value);
      notifyListeners();
    } else {
      debugPrint("Enter the value first");
    }
  }

  void deleteData(String value) {
    if (value.isNotEmpty && _data.contains(value)) {
      _data.remove(value);
      notifyListeners();
    } else {
      debugPrint("Enter a valid value to delete");
    }
  }
}

class Changes extends ConsumerWidget {
  Changes({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(valueChangesProvider).data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riverpod State Management"),
      ),
      body: Card(
        elevation: 5,
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.isNotEmpty)
                ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        data[index],
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter the value",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(valueChangesProvider).addData(controller.text.trim());
                      controller.clear();
                    },
                    child: const Text("Add"),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(valueChangesProvider).deleteData(controller.text.trim());
                      controller.clear();
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(ProviderScope(child: MaterialApp(home: Changes())));
}


/*
This Flutter application demonstrates a simple **state management** system using the **Riverpod** package and **ChangeNotifier**. It allows users to add and delete values from a dynamically managed list. Below is a detailed description of the content:

---

### **Features**:
1. **State Management**:
   - The application uses the **`ChangeNotifierProvider`** from Riverpod to manage state reactively.
   - A custom class `Satija`, extending `ChangeNotifier`, is used to hold the application state (`List<String>`).
   - The state is updated through `addData` and `deleteData` methods, which notify listeners of changes.

2. **User Interface**:
   - The UI is built using a `ConsumerWidget` named `Changes`.
   - The main screen consists of:
     - A scrollable list that displays the current values stored in the list.
     - A `TextField` to input values.
     - Two buttons:
       - **Add**: Adds the input value to the list.
       - **Delete**: Removes the input value from the list if it exists.

3. **Behavior**:
   - When a user adds a value via the `TextField`, it updates the list and refreshes the display in real time.
   - When a value is deleted, it is removed from the list and the UI updates automatically.
   - If no values are present in the list, a placeholder message ("No data available") is shown.

4. **Error Handling**:
   - Ensures the user cannot add or delete empty values.
   - Ensures only existing values in the list can be deleted, avoiding runtime errors.

5. **Best Practices Implemented**:
   - Separation of business logic (`Satija` class) and UI (`Changes` widget).
   - Type-safe operations with `List<String>`.
   - Clears the input field (`TextEditingController`) after each operation.

---

### **Structure**:
- **State Management**: The `Satija` class acts as the state manager.
- **Provider Declaration**: The `ChangeNotifierProvider` wraps the `Satija` class, making it accessible across the widget tree.
- **Widgets**:
  - `ListView.builder`: Dynamically displays the list items.
  - `TextField`: Collects user input.
  - `ElevatedButton`: Triggers `addData` and `deleteData` operations.
- **Main Function**: Initializes the app using `ProviderScope`.

---

### **Usage**:
- **Adding Data**:
  1. Type a value into the `TextField`.
  2. Press the "Add" button.
  3. The new value appears in the list.

- **Deleting Data**:
  1. Type an existing value into the `TextField`.
  2. Press the "Delete" button.
  3. The value is removed from the list if it exists.

---

This app serves as a great example of using **Riverpod** with
**ChangeNotifier** for simple state management in Flutter.
It showcases the key principles of reactivity, separation of concerns, and user-friendly interaction.
* */