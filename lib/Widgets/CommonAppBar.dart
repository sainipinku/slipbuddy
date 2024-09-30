import 'package:flutter/material.dart';

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
