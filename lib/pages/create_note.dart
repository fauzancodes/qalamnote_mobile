import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final String userId;

  const CreateNotePage({super.key, required this.userId});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _ustadzController = TextEditingController();
  final _placeController = TextEditingController();
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
  }

  void _saveNoteAndBack() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final ustadz = _ustadzController.text.trim();
    final place = _placeController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final uuid = Uuid();
    final note = Note(
      id: uuid.v4(),
      title: title,
      body: body,
      isFinished: false,
      lastEdited: DateTime.now(),
      userId: widget.userId,
      ustadz: ustadz,
      place: place,
    );

    notesBox.put(note.id, note);
    debugPrint("Note saved: $title");

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _ustadzController.dispose();
    _placeController.dispose();
    super.dispose();
  }

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
          onTap: _saveNoteAndBack,
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
              controller: _titleController,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: CustomColor.base_3,
              ),
              decoration: const InputDecoration(
                hintText: "Title here...",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _ustadzController,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CustomColor.base_3,
              ),
              decoration: const InputDecoration(
                hintText: "Ustadz name here...",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _placeController,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CustomColor.base_3,
              ),
              decoration: const InputDecoration(
                hintText: "Place name here...",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: CustomColor.base_4,
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
