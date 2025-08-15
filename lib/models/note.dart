import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  bool isFinished;

  @HiveField(4)
  DateTime? lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.body,
    this.isFinished = false,
    this.lastEdited,
  });
}
