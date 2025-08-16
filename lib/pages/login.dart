import 'package:qalamnote_mobile/components/custom_button.dart';
import 'package:qalamnote_mobile/components/custom_text.dart';
import 'package:qalamnote_mobile/components/custom_text_field.dart';
import 'package:qalamnote_mobile/components/custom_text_with_link.dart';
import 'package:qalamnote_mobile/models/user.dart';
import 'package:qalamnote_mobile/pages/register.dart';
import 'package:qalamnote_mobile/pages/note_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        MaterialPageRoute(builder: (_) => NoteListPage(userId: foundUser.id,)),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 96),
            CustomText.title("Let's Login"),
            const SizedBox(height: 16),
            CustomText.subtitle("And capture every word of wisdom from your favorite ustadz, anytime, anywhere."),
            const SizedBox(height: 32),
            CustomTextField(
              label: "Username",
              placeholder: "johndoe123",
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Password",
              placeholder: "********",
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 64),
            CustomButton(
              text: "Login",
              onPressed: _loginUser,
            ),
            const SizedBox(height: 32),
            if (box.isEmpty)
              CustomTextWithLink(
                text: "Don't have any account?",
                textLink: "Register here",
                destination: const RegisterPage(),
              ),
          ],
        ),
      ),
    );
  }
}
