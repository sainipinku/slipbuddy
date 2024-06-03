import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {}); // Simulate a delay
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Welcome(),
          ctx: context),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your logo or any widget you want to show on the splash screen
            Image.asset('assets/images/slip_buddy_logo.png',fit: BoxFit.cover,width: 350.w,),
            CircularProgressIndicator(), // Optional: show a progress indicator
          ],
        ),
      ),
    );
  }
}
