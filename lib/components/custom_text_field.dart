import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: CustomColor.base_3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: CustomColor.base_2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_3, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
