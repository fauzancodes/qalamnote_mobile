import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalamnote_mobile/pages/login.dart';
import 'models/user.dart';
import 'models/note.dart';
import 'models/place.dart';
import 'models/ustadz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(UstadzAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Place>('places');
  await Hive.openBox<Ustadz>('ustadzs');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
