import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/place.dart';
import 'package:qalamnote_mobile/models/ustadz.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateNoteForm extends StatelessWidget {
  final VoidCallback saveNoteAndBack;
  final TextEditingController titleController;
  final TextEditingController ustadzController;
  final TextEditingController placeController;
  final TextEditingController bodyController;
  final Box<Ustadz> ustadzsBoxes;
  final Box<Place> placesBoxes;

  final Widget Function<T>({
    required TextEditingController controller,
    required Box<T> box,
    required String Function(T) getName,
    required String hint,
  }) buildTypeAhead;

  const CreateNoteForm({
    super.key,
    required this.saveNoteAndBack,
    required this.titleController,
    required this.ustadzController,
    required this.placeController,
    required this.bodyController,
    required this.ustadzsBoxes,
    required this.placesBoxes,
    required this.buildTypeAhead,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: CustomColor.base_4,
            width: 1,
          ),
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: saveNoteAndBack,
          child: Row(
            children: const [
              SizedBox(width: 8),
              Icon(Icons.chevron_left, color: CustomColor.primary),
              SizedBox(width: 4),
              Text(
                "Back",
                style: TextStyle(
                  color: CustomColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: CustomColor.base_3,
              ),
              decoration: const InputDecoration(
                hintText: "Title here...",
                border: InputBorder.none,
              ),
            ),
            buildTypeAhead<Ustadz>(
              controller: ustadzController,
              box: ustadzsBoxes,
              getName: (u) => (u).fullName,
              hint: "Ustadz name here...",
            ),
            buildTypeAhead<Place>(
              controller: placeController,
              box: placesBoxes,
              getName: (p) => (p).name,
              hint: "Place name here...",
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: bodyController,
                maxLines: null,
                expands: true,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: CustomColor.base_3,
                ),
                decoration: const InputDecoration(
                  hintText: "Write your note here...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}