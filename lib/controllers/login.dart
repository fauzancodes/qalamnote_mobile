import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/models/user.dart';
import 'package:qalamnote_mobile/pages/login.dart';
import 'package:hive/hive.dart';
import 'package:qalamnote_mobile/pages/note_list.dart';
import 'package:qalamnote_mobile/views/login.dart';

class LoginPageState extends State<LoginPage> {
  var box = Hive.box<User>('users');

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginUser() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    User? foundUser = box.values.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => User(id: '', username: '', password: ''),
    );

    if (foundUser.username.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NoteListPage(userId: foundUser.id),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        usernameController: _usernameController,
        passwordController: _passwordController,
        onLogin: _loginUser,
        isBoxEmpty: box.isEmpty,
      ),
    );
  }
}