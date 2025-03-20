import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

final customTagsProvider = StateNotifierProvider<CustomTagsNotifier, List<String>>((ref) {
  return CustomTagsNotifier();
});

class CustomTagsNotifier extends StateNotifier<List<String>> {
  CustomTagsNotifier() : super([]) {
    final savedTags = box.read<List<dynamic>>('customTags') ?? [];
    state = List<String>.from(savedTags);
  }

  void addTag(String tag) {
    state = [...state, tag];
    box.write('customTags', state);
  }

  void removeTag(String tag) {
    state = state.where((t) => t != tag).toList();
    box.write('customTags', state);
  }
}

final box = GetStorage();
final List<String> defaultCategories = ["Work", "Personal", "Meeting", ];

class CustomTagsWidget extends ConsumerStatefulWidget {
  @override
  _CustomTagsWidgetState createState() => _CustomTagsWidgetState();
}

class _CustomTagsWidgetState extends ConsumerState<CustomTagsWidget> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  TextEditingController Categorycontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<String> customTags = ref.watch(customTagsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: Categorycontroller,
          readOnly: true,
          decoration: InputDecoration(
            hintStyle: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600)
                ,hintText: "Select Categroy",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            hintStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            hintText: "Enter a custom Category",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            labelText: "Add Custom Category",
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Categorycontroller.text=_tagController.text.toString();
                if (_tagController.text.isNotEmpty) {
                  ref.read(customTagsProvider.notifier).addTag(_tagController.text.trim());
                  _tagController.clear();
                }
              },
            ),
          ),
        ),
        SizedBox(height: 10),

        Text("Default Categories:", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
        Wrap(
          spacing: 8.0,
          children: defaultCategories.map((category) {
            return ChoiceChip(
              label: Text(category, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400)),
              selected: customTags.contains(category),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    Categorycontroller.text=category;
                  });
                  ref.read(customTagsProvider.notifier).removeTag(category);
                  ref.read(customTagsProvider.notifier).addTag(category);
                } else {
                  ref.read(customTagsProvider.notifier).removeTag(category);
                }
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),

        Wrap(
          spacing: 8.0,
          children: customTags.map((tag) {
            return Chip(
              label: Text(tag, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400)),
              onDeleted: () => ref.read(customTagsProvider.notifier).removeTag(tag),
            );
          }).toList(),
        ),
      ],
    );
  }
}
