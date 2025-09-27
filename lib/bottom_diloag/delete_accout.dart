
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/controller/login_auth/login_cubit.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';

DeleteAccountBottomDilog(BuildContext buildContext,String reason) {
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
              child:  LogoutWidget(reason: reason,),
            ),
          );
        },
      );
    },
  );
}

class LogoutWidget extends StatefulWidget {
  final String reason;
  const LogoutWidget({super.key,required this.reason});

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  final TextEditingController houseNumberController = TextEditingController();
  String addressType = "Home"; // Default address type
  final TextEditingController phoneController = TextEditingController();
  late LoginCubit loginCubit;
  final formkey = GlobalKey<FormState>();
  late BuildContext buildContext;
  initCubit(){
    loginCubit = context.read<LoginCubit>();
  }
  String selectedRole = '';
  String? creds;
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Delete Account?",
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.blackColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Are you sure do you wanna Delete Account?",
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
                    child: button(color: AppTheme.statusBar, text: 'Yes', button: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      SharedPref.removeAll();
                      String userToken = prefs.getString('user_id') ?? '';
                      String userID = prefs.getString('user_token') ?? '';
                      String userPhone = prefs.getString('user_phone') ?? '';
                      Navigator.pop(context);
                      var map = {
                        "MsrNo": userToken,
                        "UserId": userID,
                        "Mobile": userPhone,
                        "Reason":widget.reason};
                      print('send data ======>$map');
                      loginCubit.getDeleteAccount(map);
                    },borderRadius: 5.0),
                  ),
                ),
              ],
            )

          ],
        ),
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