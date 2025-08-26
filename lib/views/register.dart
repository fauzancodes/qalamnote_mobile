import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/components/custom_app_bar.dart';
import 'package:qalamnote_mobile/components/custom_button.dart';
import 'package:qalamnote_mobile/components/custom_text.dart';
import 'package:qalamnote_mobile/components/custom_text_field.dart';
import 'package:qalamnote_mobile/components/custom_text_with_link.dart';
import 'package:qalamnote_mobile/pages/login.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onRegister,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
            CustomText.title(
              "Register",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomText.subtitle(
              "And start recording lectures from your ustadz. Organize your notes, revisit them anytime, and keep your journey of learning alive.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: "Username",
              placeholder: "Example: johndoe123",
              controller: usernameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Password",
              placeholder: "********",
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 64),
            CustomButton(
              text: "Register",
              onPressed: onRegister,
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