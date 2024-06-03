import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';


Widget button ({required Color color,required String text,required VoidCallback button,double? borderRadius}){
    return GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        height: 45.h,
        width: 150.w,
        child: ElevatedButton(
          onPressed: () {
            button();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 25.0)),
          ),
          child: Text('GET STARTED',style: GoogleFonts.roboto(
            textStyle:  TextStyle(
              color: AppTheme.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w500, // regular
            ),
          ),),
        ),
      ),
    );
}