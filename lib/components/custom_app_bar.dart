import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/components/custom_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Row(
        children: [
          if (showBack)
            InkWell(
              onTap: onBack ?? () => Navigator.pop(context),
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
          if (!showBack) const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: CustomColor.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
