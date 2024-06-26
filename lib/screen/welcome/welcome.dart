import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/constants/my_styles.dart';
import 'package:slipbuddy/screen/auth/login.dart';
import 'package:slipbuddy/screen/login_signup/login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        elevation: 0,
        title: Center(
          child: Container(
            height: 20.h,
            width: 120.w,
            child: Stack(
              children: [
                Container(
                  height: 20.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/slip_buddy_logo.png",
                  width: 350.w,
                ),
                SizedBox(height: 50.h,),
                Text(
                  'SLIP BUDDY!',
                  style: MyStyles.black35Medium,
                ),
                Text(
                  'Care made easy',
                  style: MyStyles.black20Medium,
                ),
                SizedBox(height: 20.h,),
                Text(
                  'Welcome to SLIP BUDDY!',
                  style: MyStyles.black16Light,
                ),
                Text(
                  'Simplify your healthcare journey with'
                      'easy appointment booking, real-time'
                      'updates, and personalized care management.',
                  textAlign: TextAlign.center,
                  style: MyStyles.black14Light,
                ),
                SizedBox(height: 20),
                button(color: AppTheme.blackColor,text: 'Get Start',button: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: Login(),
                        ctx: context),
                        (route) => false,
                  );
                }),
              ],
            ),
          ),
        ),
        ),
      );
  }
}
