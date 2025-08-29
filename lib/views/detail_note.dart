import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalamnote_mobile/components/custom_app_bar.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/place.dart';
import 'package:qalamnote_mobile/models/ustadz.dart';

class DetailNoteForm extends StatelessWidget {
  final VoidCallback updateNoteAndBack;
  final TextEditingController titleController;
  final TextEditingController ustadzController;
  final TextEditingController placeController;
  final TextEditingController bodyController;
  final Box<Ustadz> ustadzsBoxes;
  final Box<Place> placesBoxes;
  final String Function() getLastEditedText;
  final VoidCallback showActionModal;

  final Widget Function<T>({
    required TextEditingController controller,
    required Box<T> box,
    required String Function(T) getName,
    required String hint,
  }) buildTypeAhead;

  const DetailNoteForm({
    super.key,
    required this.updateNoteAndBack,
    required this.titleController,
    required this.ustadzController,
    required this.placeController,
    required this.bodyController,
    required this.ustadzsBoxes,
    required this.placesBoxes,
    required this.getLastEditedText,
    required this.showActionModal,
    required this.buildTypeAhead,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBack: updateNoteAndBack),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: TextField(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildTypeAhead<Ustadz>(
                controller: ustadzController,
                box: ustadzsBoxes,
                getName: (u) => (u).fullName,
                hint: "Ustadz name here...",
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: buildTypeAhead<Place>(
                controller: placeController,
                box: placesBoxes,
                getName: (p) => (p).name,
                hint: "Place name here...",
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 48,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: CustomColor.base_4, width: 1),
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getLastEditedText(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CustomColor.base_3,
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: IconButton(
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: CustomColor.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: showActionModal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}