
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/models/note.dart';
import 'package:qalamnote_mobile/models/place.dart';
import 'package:qalamnote_mobile/models/ustadz.dart';
import 'package:qalamnote_mobile/pages/create_note.dart';
import 'package:qalamnote_mobile/views/create_note.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _ustadzController = TextEditingController();
  final _placeController = TextEditingController();

  late Box<Note> notesBox;
  late Box<Ustadz> ustadzsBoxes;
  late Box<Place> placesBoxes;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    ustadzsBoxes = Hive.box<Ustadz>('ustadzs');
    placesBoxes = Hive.box<Place>('places');
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

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _ustadzController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Widget buildTypeAhead<T>({
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
      body: CreateNoteForm(
        saveNoteAndBack: _saveNoteAndBack, 
        titleController: _titleController, 
        ustadzController: _ustadzController, 
        placeController: _placeController, 
        bodyController: _bodyController,
        ustadzsBoxes: ustadzsBoxes, 
        placesBoxes: placesBoxes, 
        buildTypeAhead: buildTypeAhead)
      );
  }
}