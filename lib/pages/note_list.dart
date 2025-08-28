import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/note.dart';
import 'package:qalamnote_mobile/pages/create_note.dart';
import 'package:qalamnote_mobile/pages/credential.dart';
import 'package:qalamnote_mobile/pages/detail_note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CustomColor.base_4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(box.length, (index) {
                  final note = box.getAt(index);
                  if (note == null || note.userId != userId) return const SizedBox();

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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.base_3,
                                  ),
                                ),
                              ),
                              if (note.isFinished)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green, size: 20
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.body,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: CustomColor.base_3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: CustomColor.base_1,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 64,
                  child: FloatingActionButton(
                    heroTag: "user_btn",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CredentialPage(userId: userId),
                        ),
                      );
                    },
                    backgroundColor: CustomColor.base_2,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.person, size: 32, color: CustomColor.base_3),
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: CustomColor.base_1,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 64,
                  child: FloatingActionButton(
                    heroTag: "add_btn",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateNotePage(userId: userId),
                        ),
                      );
                    },
                    backgroundColor: CustomColor.primary,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, size: 32, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
