import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/note.dart';
import 'package:qalamnote_mobile/models/place.dart';
import 'package:qalamnote_mobile/models/ustadz.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailNotePage extends StatefulWidget {
  final String noteKey;
  final String userId;

  const DetailNotePage({super.key, required this.noteKey, required this.userId});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _ustadzController;
  late TextEditingController _placeController;
  late Box<Note> notesBox;
  late Box<Ustadz> ustadzsBoxes;
  late Box<Place> placesBoxes;
  late Note note;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    ustadzsBoxes = Hive.box<Ustadz>('ustadzs');
    placesBoxes = Hive.box<Place>('places');

    note = notesBox.get(widget.noteKey)!;

    _titleController = TextEditingController(text: note.title);
    _bodyController = TextEditingController(text: note.body);
    _ustadzController = TextEditingController(text: note.ustadz);
    _placeController = TextEditingController(text: note.place);
  }

  void _updateNoteAndBack() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final ustadz = _ustadzController.text.trim();
    final place = _placeController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final updatedNote = Note(
      id: note.id,
      title: title,
      body: body,
      isFinished: note.isFinished,
      lastEdited: DateTime.now(),
      userId: widget.userId,
      ustadz: ustadz,
      place: place,
    );

    notesBox.put(widget.noteKey, updatedNote);
    debugPrint("Note updated (UUID: ${widget.noteKey})");

    if (ustadz.isNotEmpty) {
      final exists = ustadzsBoxes.values.any(
        (u) => u.fullName.toLowerCase() == ustadz.toLowerCase(),
      );
      if (!exists) {
        ustadzsBoxes.put(
          Uuid().v4(),
          Ustadz(id: Uuid().v4(), fullName: ustadz),
        );
      }
    }

    if (place.isNotEmpty) {
      final exists = placesBoxes.values.any(
        (p) => p.name.toLowerCase() == place.toLowerCase(),
      );
      if (!exists) {
        placesBoxes.put(
          Uuid().v4(),
          Place(id: Uuid().v4(), name: place),
        );
      }
    }

    Navigator.pop(context);
  }

  void _showActionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 64),
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(
                      note.isFinished ? "Mark as Unfinished" : "Mark as Finished",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      final updatedNote = Note(
                        id: note.id,
                        title: _titleController.text.trim(),
                        body: _bodyController.text.trim(),
                        isFinished: !note.isFinished,
                        lastEdited: DateTime.now(),
                        userId: widget.userId,
                      );
                      notesBox.put(widget.noteKey, updatedNote);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: CustomColor.base_4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(
                      "Delete Note",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      notesBox.delete(widget.noteKey);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: CustomColor.base_2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: CustomColor.base_4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getLastEditedText() {
    final edited = note.lastEdited ?? DateTime.now();
    final now = DateTime.now();

    final isSameDay = edited.year == now.year &&
        edited.month == now.month &&
        edited.day == now.day;

    if (isSameDay) {
      return "Last edited at ${edited.hour.toString().padLeft(2, '0')}:${edited.minute.toString().padLeft(2, '0')}";
    } else {
      return "Last edited on ${edited.day.toString().padLeft(2, '0')}/${edited.month.toString().padLeft(2, '0')}/${edited.year}";
    }
  }


  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _ustadzController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Widget _buildTypeAhead<T>({
    required TextEditingController controller,
    required Box<T> box,
    required String Function(T) getName,
    required String hint,
  }) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<T> _, __) {
        return TypeAheadField<String>(
          key: ValueKey(box.values.map(getName).join(",")),
          controller: controller,
          suggestionsCallback: (pattern) {
            final q = pattern.toLowerCase();
            final results = box.values
                .map((e) => getName(e).trim())
                .where((name) => name.isNotEmpty && name.toLowerCase().contains(q))
                .toSet()
                .toList();

            results.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
            return results;
          },
          builder: (context, textController, focusNode) {
            return TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CustomColor.base_3,
              ),
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  final key = box.keys.firstWhere(
                    (k) => getName(box.get(k) as T).toLowerCase() ==
                        suggestion.toLowerCase(),
                    orElse: () => null,
                  );
                  if (key != null) {
                    box.delete(key);

                    debugPrint("Deleted: $suggestion");
                  }
                },
              ),
            );
          },
          onSelected: (suggestion) {
            controller.text = suggestion;
          },
          hideOnEmpty: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: CustomColor.base_4, width: 1),
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: _updateNoteAndBack,
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
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: TextField(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildTypeAhead<Ustadz>(
                controller: _ustadzController,
                box: ustadzsBoxes,
                getName: (u) => (u).fullName,
                hint: "Ustadz name here...",
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: _buildTypeAhead<Place>(
                controller: _placeController,
                box: placesBoxes,
                getName: (p) => (p).name,
                hint: "Place name here...",
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                fontSize: 12,
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
                onPressed: _showActionModal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
