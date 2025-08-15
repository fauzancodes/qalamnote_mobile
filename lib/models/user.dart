import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });
}
