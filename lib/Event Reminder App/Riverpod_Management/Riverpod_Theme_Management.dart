import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
List<String> colorsname = [
  'green',
  'purple',
  'yellow',
  'red',
  'blue',
  'cyan',
  'black',
  'grey',
  'deepPurple',
  'deepOrange',
  'purple',
];
List<int> fontvalue = [
10,
15,
18,
20,


];
List<Color> colorsPick = [
  Colors.green,
  Colors.purple,
  Colors.yellow,
  Colors.red,
  Colors.blue,
  Colors.cyanAccent.shade700,
  Colors.black87,
  Colors.grey.shade700,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.purple,
];


final colorsvalue=StateProvider<int>((ref) => 0);



class colortheme extends ConsumerWidget {
  const colortheme({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int colorindex = ref.watch(colorsvalue);
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        itemCount: colorsPick.length,
        itemBuilder: (context, index) {
          return GestureDetector(

            child: Container( )
          );
        },
      ),
    );
        }}




