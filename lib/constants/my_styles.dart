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
  static TextStyle black12Light = GoogleFonts.openSans(
    textStyle: const TextStyle(
      color: AppTheme.blackColor,
      fontSize: 12,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle black14Light = GoogleFonts.openSans(
    textStyle: const TextStyle(
      color: AppTheme.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle blu14bold = GoogleFonts.openSans(
    textStyle: const TextStyle(
      color: Colors.blue,
      fontSize: 14,
      fontWeight: FontWeight.w400, // regular
    ),
  );
  static TextStyle black35Medium = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 35,
      letterSpacing: 2,
      fontWeight: MyFontWeight.extraBold, // regular
    ),
  );
  static TextStyle black20Medium = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 20,
      fontWeight: MyFontWeight.medium, // regular
    ),
  );
    static TextStyle white22ExtraBold = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.whiteColor,
      fontSize: 22,
      fontWeight: MyFontWeight.extraBold, // regular
    ),
  );
    static TextStyle black25Medium = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 25,
      fontWeight: MyFontWeight.medium, // regular
    ),
  );
  static TextStyle black22bold = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 22,
      fontWeight: MyFontWeight.bold, // regular
    ),
  );
  static TextStyle black16Light = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 16,
      fontWeight: MyFontWeight.light, // regular
    ),
  );
  
    static TextStyle black16Bold = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: AppTheme.blackColor,
      fontSize: 16,
      fontWeight: MyFontWeight.bold, // regular
    ),
  );
  static TextStyle whiteGry20Light = GoogleFonts.openSans(
    textStyle:  TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: MyFontWeight.light, // regular
    ),
  );
}