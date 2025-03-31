
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';

LogoutBottomDilog(BuildContext buildContext) {
  showModalBottomSheet<void>(
    context: buildContext,
    isScrollControlled: true,
    backgroundColor: AppTheme.whiteColor,
    shape: const RoundedRectangleBorder( // <-- SEE HERE
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const LogoutWidget(),
            ),
          );
        },
      );
    },
  );
}

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({super.key});

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  final TextEditingController houseNumberController = TextEditingController();
  String addressType = "Home"; // Default address type
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Logout?",
            style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Are you sure do you wanna logout?",
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.bgColor),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: button(color: AppTheme.statusBar, text: 'No', button: () {
                    Navigator.pop(context);
                  },borderRadius: 5.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: button(color: AppTheme.statusBar, text: 'Yes', button: () {
                    Navigator.pop(context);
                    _logout(context);
                  },borderRadius: 5.0),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
  void _logout(BuildContext context) {
    // Perform logout logic here
    // For example, clear user session or token
    // Navigate back to the login screen
    SharedPref.removeAll();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Welcome()),
    );
  }
}