import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/components/custom_button.dart';
import 'package:qalamnote_mobile/components/custom_text.dart';
import 'package:qalamnote_mobile/components/custom_text_field.dart';
import 'package:qalamnote_mobile/components/custom_text_with_link.dart';
import 'package:qalamnote_mobile/pages/register.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isBoxEmpty;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    required this.isBoxEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 96),
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
            CustomText.title(
              "Let's Login",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomText.subtitle(
              "And capture every word of wisdom from your favorite ustadz, anytime, anywhere.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: "Username",
              placeholder: "johndoe123",
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
              text: "Login",
              onPressed: onLogin,
            ),
            const SizedBox(height: 32),
            if (isBoxEmpty)
              const CustomTextWithLink(
                text: "Don't have any account?",
                textLink: "Register here",
                destination: RegisterPage(),
              ),
          ],
        ),
      ),
    );
  }
}