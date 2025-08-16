import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/note.dart';
import 'package:qalamnote_mobile/pages/create_note.dart';
import 'package:qalamnote_mobile/pages/detail_note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteListPage extends StatelessWidget {
  final String userId;

  const NoteListPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    var notesBox = Hive.box<Note>('notes');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_note.png',
                    width: 245,
                    height: 219,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Text(
                      'Your journey of knowledge starts here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.base_3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Text(
                      'Start adding notes from your ustadz’s lectures so you can revisit and reflect on them anytime. Capture wisdom before it fades.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: CustomColor.base_4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/empty_note_arrow.png',
                    width: 169,
                    height: 123,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index);
                if (note == null) return const SizedBox();

                if (note.userId == userId) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailNotePage(
                            noteKey: note.id,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColor.base_1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.base_3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (note.isFinished)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.body.length > 150
                                ? '${note.body.substring(0, 150)}...'
                                : note.body,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: CustomColor.base_4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return null;
              },
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CustomColor.base_1,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 64,
            height: 64,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateNotePage(userId: userId)),
                );
              },
              backgroundColor: CustomColor.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
