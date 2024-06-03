import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLoadingWidget extends StatefulWidget {
  const AnimatedLoadingWidget({super.key});

  @override
  State<AnimatedLoadingWidget> createState() => _AnimatedLoadingWidgetState();
}

class _AnimatedLoadingWidgetState extends State<AnimatedLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Image.asset(
          "assets/images/loader.gif",
          width: 150.w,
        ),
      ),
    );
  }
}
