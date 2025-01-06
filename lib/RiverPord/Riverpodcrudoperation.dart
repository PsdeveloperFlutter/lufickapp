//CRUD OPERATION IN RIVER POD STATE PROVIDER
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the crudops object
final crudOpsProvider = ChangeNotifierProvider<CrudOps>((ref) => CrudOps());

class CrudOps with ChangeNotifier {
  List<dynamic> _data = [];

  List<dynamic> get data => _data;

  void add(dynamic value) {
    if(value != null && value.isNotEmpty){
      _data.add(value);
      notifyListeners();
    }
  }

  void delete(dynamic value) {
    if(value != null){
      _data.remove(value);
      notifyListeners();
    }
  }
}

class RiverpodCrudOperation extends ConsumerWidget {
  RiverpodCrudOperation({Key? key}) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the crudOpsProvider to rebuild the widget when the data changes
    final crudOps = ref.watch(crudOpsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod CRUD Operation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: crudOps.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(crudOps.data[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Delete an item from the list
                        ref.read(crudOpsProvider).delete(crudOps.data[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter a task',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Add an item to the list
                if(controller.text.isNotEmpty){
                  ref.read(crudOpsProvider).add(controller.text);
                  controller.clear();
                } else {
                  print("Please enter a task");
                }
              },
              child: const Text('Add Item'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RiverpodCrudOperation(),
      ),
    ),
  );
}


/*
Provider: A basic provider that holds a value and notifies its listeners when the value changes.
ChangeNotifierProvider: A provider that holds a ChangeNotifier object and notifies its listeners when the object changes.
StateNotifierProvider: A provider that holds a StateNotifier object and notifies its listeners when the object changes.
FutureProvider: A provider that holds a Future object and notifies its listeners when the future completes.
StreamProvider: A provider that holds a Stream object and notifies its listeners when the stream emits a new event.
NotifierProvider: A provider that holds a Notifier object and notifies its listeners when the object changes.
AutoDisposeProvider: A provider that automatically disposes of its resources when it is no longer needed.
DisposeProvider: A provider that manually disposes of its resources when it is no longer needed.
ProxyProvider: A provider that proxies another provider, allowing you to modify the behavior of the original provider.
ScopedProvider: A provider that is scoped to a specific part of the app, allowing you to manage state and dependencies in a more modular way.
ChangeNotifierProxyProvider: A provider that proxies a ChangeNotifier object and notifies its listeners when the object changes.
StateNotifierProxyProvider: A provider that proxies a StateNotifier object and notifies its listeners when the object changes.
FutureProxyProvider: A provider that proxies a Future object and notifies its listeners when the future completes.
StreamProxyProvider: A provider that proxies a Stream object and notifies its listeners when the stream emits a new event.
NotifierProxyProvider: A provider that proxies a Notifier object and notifies its listeners when the object changes.
Computed: A provider that computes a value based on other providers and notifies its listeners when the value changes.
DerivedProvider: A provider that derives its value from other providers and notifies its listeners when the value changes.
NotifierProvider.family: A provider that creates a new notifier for each set of arguments.
StateNotifierProvider.family: A provider that creates a new state notifier for each set of arguments.
ChangeNotifierProvider.family: A provider that creates a new change notifier for each set of arguments.
Note that this list may not be exhaustive, as new providers may be added to Riverpod in the future.
* */