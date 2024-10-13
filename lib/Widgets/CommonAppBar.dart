import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final bool showBackButton;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor = Colors.blue,
    this.titleColor = Colors.white,
    this.showBackButton = false, // New parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back, color: titleColor),
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      )
          : null,
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
Widget commonButton({
  required Color color,
  required String text,
  required VoidCallback button,
  double? borderRadius,
}) {
  return GestureDetector(
    onTap: () {
      // Custom tap logic
    },
    child: SizedBox(
      height: 45.h,
      width: double.infinity, // Set to full width
      child: ElevatedButton(
        onPressed: button,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(
            color: AppTheme.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}