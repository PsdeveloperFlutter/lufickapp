import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Riverpod_Management/Riverpod_add_Management.dart'; // Import provider file
import 'package:google_fonts/google_fonts.dart';
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
    final List<String> customTags = ref.watch(customTagsProvider).map((tag) => tag.toString()).toList(); // Safe conversion

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
                  _tagController.clear();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Displaying custom tags as Chips (Safe conversion)
        Wrap(
          spacing: 8.0,
          children: customTags.map((tag) {
            return Chip(
              label: Text(tag,style:GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),),
              onDeleted: () => ref.read(customTagsProvider.notifier).removeTag(tag),
            );
          }).toList(),
        ),
      ],
    );
  }
}
