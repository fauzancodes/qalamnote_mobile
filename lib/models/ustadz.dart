import 'package:hive/hive.dart';

part 'ustadz.g.dart';

@HiveType(typeId: 3)
class Ustadz {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  Ustadz({
    required this.id,
    required this.fullName,
  });
}
