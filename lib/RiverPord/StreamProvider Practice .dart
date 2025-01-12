import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'FutureProviderPractice.dart';

// In this code, I create a class which fetch the StateNotifierProvider and I pass two pass ValueNotifier
// which is the StateNotifier class and second parameter is the itemnotifiers class
// which is the state in this code I which I can manage the code in this code I have create the state class and
// set the required parameter in this code and second I create the copywith method in this code and set this class to
// the StateNotifier parameter and make sure  super code Will be passed in this code and
// super code set the parent class object an initialized and set the
// function which is name is feddata and set the data through it and set the copywith method and
// set this code to run

final values = StreamProvider((ref) async* {
  for (int i = 0; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
});

class Screen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<int> value = ref.watch(values);

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              value.when(
                data: (data) {
                  return Text(data.toString());
                },
                error: (error, stackTrace) {
                  return Text(error.toString());
                },
                loading: () {
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
        )
    );
  }
}

void main() {
  runApp(ProviderScope(child: MaterialApp(home: screens())));
}