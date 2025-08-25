import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/models/user.dart';
import 'package:qalamnote_mobile/pages/login.dart';
import 'package:qalamnote_mobile/pages/register.dart';
import 'package:hive/hive.dart';
import 'package:qalamnote_mobile/views/register.dart';
import 'package:uuid/uuid.dart';

class RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerUser() async {
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

    var box = Hive.box<User>('users');

    final uuid = Uuid();
    User newUser = User(
      id: uuid.v4(),
      username: username,
      password: password,
    );
    await box.put(newUser.id, newUser);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterForm(
        usernameController: _usernameController,
        passwordController: _passwordController,
        onRegister: _registerUser,
      ),
    );
  }
}