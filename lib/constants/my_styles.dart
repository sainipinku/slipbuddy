import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class MyFontWeight {
  static FontWeight light = FontWeight.w400;
  static FontWeight regular = FontWeight.w500;
  static FontWeight medium = FontWeight.w600;
  static FontWeight semiBold = FontWeight.bold;
  static FontWeight bold = FontWeight.w800;
  static FontWeight extraBold = FontWeight.w900;
}

class MyStyles {
  static TextStyle black12Light = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppTheme.blackColor,
      fontSize: 12,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle black14Light = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppTheme.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle blu14bold = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: Colors.blue,
      fontSize: 14,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle black35Medium = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 35,
      letterSpacing: 2,
      fontWeight: MyFontWeight.extraBold, // regular
    ),
  );
  static TextStyle black20Medium = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 20,
      fontWeight: MyFontWeight.medium, // regular
    ),
  );
    static TextStyle white22ExtraBold = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.whiteColor,
      fontSize: 22,
      fontWeight: MyFontWeight.extraBold, // regular
    ),
  );
    static TextStyle black25Medium = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 25,
      fontWeight: MyFontWeight.medium, // regular
    ),
  );
  static TextStyle black22bold = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 22,
      fontWeight: MyFontWeight.bold, // regular
    ),
  );
  static TextStyle black16Light = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 16,
      fontWeight: MyFontWeight.light, // regular
    ),
  );
  
    static TextStyle black16Medium = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 16,
      fontWeight: MyFontWeight.regular, // regular
    ),
  );
  static TextStyle whiteGry20Light = GoogleFonts.poppins(
    textStyle:  TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: MyFontWeight.light, // regular
    ),
  );
}