import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/controllers/detail_note.dart';

class DetailNotePage extends StatefulWidget {
  final String noteKey;
  final String userId;

  const DetailNotePage({super.key, required this.noteKey, required this.userId});

  @override
  State<DetailNotePage> createState() => DetailNotePageState();
}
