import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/screen/auth/login.dart';
import 'package:slipbuddy/screen/dashboard/home_screen.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Welcome(),
            ctx: context),
            (route) => false,
      );
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.statusBar, // Set your desired status bar color here
      statusBarBrightness: Brightness.light, // For iOS: set the status bar text color to light
      statusBarIconBrightness: Brightness.light, // For Android: set the status bar icons to light
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/slip_buddy_logo.png",
              width: 250.w,
            ),
          ),
        ],
      ),
    );
  }
}
