import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  User({
    required this.id,
    required this.username,
    required this.password,
  });
}
