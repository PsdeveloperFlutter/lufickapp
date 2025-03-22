import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

final customTagsProvider =
StateNotifierProvider<CustomTagsNotifier, List<String>>((ref) {
  return CustomTagsNotifier();
});

class CustomTagsNotifier extends StateNotifier<List<String>> {
  CustomTagsNotifier() : super([]) {
    final savedTags = box.read<List<dynamic>>('customTags') ?? [];
    state = List<String>.from(savedTags);
  }

  void addTag(String tag) {
    if (!state.contains(tag)) {
      state = [...state, tag];
      box.write('customTags', state);
    }
  }

  void removeTag(String tag) {
    state = state.where((t) => t != tag).toList();
    box.write('customTags', state);
  }
}

final List<String> defaultCategories = ["Work", "Personal", "Meeting"];

class CustomTagsWidget extends ConsumerStatefulWidget {
  @override
  _CustomTagsWidgetState createState() => _CustomTagsWidgetState();
}

class _CustomTagsWidgetState extends ConsumerState<CustomTagsWidget> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
   String fetchvalue=" ";
  @override
  void dispose() {
    _tagController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTags = ref.watch(customTagsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category",
          style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),

        /// TextField to Display Selected Category
        TextField(
          controller: categoryController,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        SizedBox(height: 15),

        /// Default Categories Section
        Text(
          "Default Categories:",
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: 8.0,
                children: defaultCategories.map((category) {
                  return ChoiceChip(
                    label: Text(
                      category,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    selected: categoryController.text == category,
                    onSelected: (bool selected) {
                      if (selected) {
                        categoryController.text = category; // Update selected category
                      } else {
                        categoryController.clear(); // Clear when unselected
                      }
                    },
                  );
                }).toList(),
              ),
              IconButton(onPressed: (){
                showCustomCategoryDialog(context,ref,categoryController);
              }, icon: Icon(Icons.add))
            ],
          ),
        ),
        SizedBox(height: 15),

      ],
    );
  }







//This is the code of the Show Dialog Box Make sure of that
  void showCustomCategoryDialog(BuildContext context, WidgetRef ref, TextEditingController categoryController) {
    final TextEditingController _tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Add Custom Category",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: _tagController,
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
              labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
              hintText: "Enter a custom Category",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: "Add Custom Category",
              suffixIcon: IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  final tag = _tagController.text.trim();
                  if (tag.isNotEmpty) {
                    categoryController.text = tag; // Update text field
                    setState(() {
                      fetchvalue=categoryController.text.toString();
                    });
                    ref.read(customTagsProvider.notifier).addTag(tag);
                    _tagController.clear();
                    Navigator.pop(context); // Close the dialog after adding
                  }
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

}









