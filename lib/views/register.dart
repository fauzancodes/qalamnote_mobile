import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/components/custom_button.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';
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