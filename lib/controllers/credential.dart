import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/models/user.dart';
import 'package:qalamnote_mobile/pages/credential.dart';
import 'package:hive/hive.dart';
import 'package:qalamnote_mobile/pages/note_list.dart';
import 'package:qalamnote_mobile/views/credential.dart';

class CredentialPageState extends State<CredentialPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late Box<User> usersBox;
  late User user;

  @override
  void initState() {
    super.initState();
    usersBox = Hive.box<User>('users');

    user = usersBox.get(widget.userId)!;

    _usernameController = TextEditingController(text: user.username);
    _passwordController = TextEditingController(text: user.password);
  }

  void _updateUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('username must be at least 3 characters long'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#!$%&?])[A-Za-z\d@#!$%&?]{8,}$',
    );
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 8 characters, include upper & lower case letters, a number, and a symbol (@#!\$%&?)',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    final updatedUser = User(
      id: user.id,
      username: username,
      password: password,
    );
    usersBox.put(updatedUser.id, updatedUser);
    debugPrint("User updated (UUID: ${widget.userId})");

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update credential successful'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => NoteListPage(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CredentialForm(
        usernameController: _usernameController,
        passwordController: _passwordController,
        onUpdate: _updateUser,
      ),
    );
  }
}