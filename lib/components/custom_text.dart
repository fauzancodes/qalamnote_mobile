import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const CustomText._(this.text, this.style, {super.key});

  factory CustomText.title(String text, {Key? key}) {
    return CustomText._(
      text,
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: CustomColor.base_3,
      ),
      key: key,
    );
  }

  factory CustomText.subtitle(String text, {Key? key}) {
    return CustomText._(
      text,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: CustomColor.base_4,
      ),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
