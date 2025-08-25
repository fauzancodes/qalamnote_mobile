import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/controllers/create_note.dart';

class CreateNotePage extends StatefulWidget {
  final String userId;

  const CreateNotePage({super.key, required this.userId});

  @override
  State<CreateNotePage> createState() => CreateNotePageState();
}
