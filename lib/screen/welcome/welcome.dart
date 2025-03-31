import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/constants/my_styles.dart';
import 'package:slipbuddy/screen/auth/login.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static  TextStyle black35Medium = TextStyle(
    fontSize: 35,
    color: Colors.black,
    fontFamily: 'BauhausItalic',
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.PNG",
                      width: 100,height: 100,
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                      'Slip Buddy',
                      style: black35Medium,
                    ),
                    Text(
                      'Care made easy',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Welcome to ', // सामान्य टेक्स्ट
                        style:GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Slip Buddy!'.toUpperCase(), // क्लिकेबल टेक्स्ट
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {

                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Simplify your healthcare journey with'
                          'easy appointment booking, real-time'
                          'updates, and personalized care management.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    button(color: AppTheme.bgColor,text: 'Get Started'.toUpperCase(),button: () {
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
                )



              ],
            ),
          ),
        ),
        ),
      );
  }
}
