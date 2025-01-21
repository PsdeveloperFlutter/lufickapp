import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart'; // Make sure to import GetStorage

// Define the custom tags provider as per your requirement
final customTagsProvider = StateNotifierProvider<CustomTagsNotifier, List<String>>((ref) {
  return CustomTagsNotifier();
});

// Notifier to manage custom tags
class CustomTagsNotifier extends StateNotifier<List<String>> {
  CustomTagsNotifier() : super([]) {
    // Initialize tags from GetStorage, ensure correct type using List<String>.from
    final savedTags = box.read<List<dynamic>>('customTags') ?? [];
    state = List<String>.from(savedTags);  // Safely cast to List<String>
  }

  void addTag(String tag) {
    state = [...state, tag]; // Add new tag
    box.write('customTags', state); // Save the updated tags list to GetStorage
  }

  void removeTag(String tag) {
    state = state.where((t) => t != tag).toList(); // Remove tag
    box.write('customTags', state); // Save the updated tags list to GetStorage
  }
}

final box = GetStorage(); // GetStorage instance to save and retrieve data

// Widget to display and manage custom tags
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

  @override
  Widget build(BuildContext context) {
    final List<String> customTags = ref.watch(customTagsProvider); // Directly watch the tags provider

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field to add a new custom tag
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            hintText: "Enter a custom tag",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            labelText: "Add Custom Tag",
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (_tagController.text.isNotEmpty) {
                  ref.read(customTagsProvider.notifier).addTag(_tagController.text.trim());
                  _tagController.clear(); // Clear the text field after adding the tag
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Displaying custom tags as Chips
        Wrap(
          spacing: 8.0,
          children: customTags.map((tag) {
            return Chip(
              label: Text(
                tag,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onDeleted: () => ref.read(customTagsProvider.notifier).removeTag(tag),
            );
          }).toList(),
        ),
      ],
    );
  }
}
