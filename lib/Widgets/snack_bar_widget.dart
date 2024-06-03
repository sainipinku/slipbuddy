import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SnackBar snackBar(title, icon, color) {
  return SnackBar(
    duration: Duration(seconds: 1),
    content: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(30.0.w),
    backgroundColor: color,
  );
}
