import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? ustadz;

  @HiveField(3)
  String? place;

  @HiveField(4)
  String body;

  @HiveField(5)
  bool isFinished;

  @HiveField(6)
  DateTime? lastEdited;

  @HiveField(7)
  String userId;

  Note({
    required this.id,
    required this.title,
    this.ustadz,
    this.place,
    required this.body,
    this.isFinished = false,
    this.lastEdited,
    required this.userId,
  });
}
