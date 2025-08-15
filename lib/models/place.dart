import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 0)
class Place {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Place({
    required this.id,
    required this.name,
  });
}
