import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: CustomColor.base_3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(color: CustomColor.base_4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CustomColor.base_3, width: 2),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.lock : Icons.lock_open,
                      color: CustomColor.base_4,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
