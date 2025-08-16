import 'package:qalamnote_mobile/components/custom_button.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
import 'package:qalamnote_mobile/components/custom_text.dart';
import 'package:qalamnote_mobile/components/custom_text_field.dart';
import 'package:qalamnote_mobile/components/custom_text_with_link.dart';
import 'package:qalamnote_mobile/models/user.dart';
import 'package:qalamnote_mobile/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: CustomColor.base_4,
            width: 1,
          ),
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: const [
              SizedBox(width: 8),
              Icon(Icons.chevron_left, color: CustomColor.primary),
              SizedBox(width: 4),
              Text(
                "Back",
                style: TextStyle(
                  color: CustomColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CustomText.title("Register"),
            const SizedBox(height: 16),
            CustomText.subtitle("And start recording lectures from your ustadz. Organize your notes, revisit them anytime, and keep your journey of learning alive."),
            const SizedBox(height: 32),
            CustomTextField(
              label: "Username",
              placeholder: "Example: johndoe123",
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
              text: "Register",
              onPressed: _registerUser,
            ),
            const SizedBox(height: 32),
            CustomTextWithLink(
              text: "Already have an account?",
              textLink: "Login here",
              destination: const LoginPage(),
            ),
          ],
        ),
      ),
    );
  }
}
