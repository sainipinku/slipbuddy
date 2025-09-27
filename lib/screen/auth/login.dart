import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';

import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/my_styles.dart';
import 'package:slipbuddy/controller/login_auth/login_cubit.dart';
import 'package:slipbuddy/screen/auth/otp.dart';
import 'package:slipbuddy/webviewpage.dart';
import 'package:url_launcher/url_launcher.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController phoneController = TextEditingController();
  late LoginCubit loginCubit;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
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
  static  TextStyle black35Medium = GoogleFonts.poppins(
    fontSize: 32,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result = await _auth.signInWithCredential(authCredential);
        User? user = result.user;
        creds = result.credential?.accessToken.toString();
        debugPrint('result =================> $result');
        debugPrint('result =================> $creds');
        debugPrint('result =================> ${result.credential}');
        debugPrint('user =================> $user');
        debugPrint('user =================> $user');
        debugPrint('user =================> $user');

        // if (result != null) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => const StoryScreen()));
        // }  // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
      }
    } catch (error) {
      print("error===============================> $error");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_ctx) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.bgColor,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Text('Loading...')
                        ],
                      ),
                    ),
                  );
                });
          } else if (state is LoginSuccess) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Otp(time: 120, phone: phoneController.text.trim(),
                  ),
                  ctx: context),
            );
          } else if (state is LoginResendSuccess) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Otp sent successfully', Icons.done, Colors.green);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is LoginFailed) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Failed to send an OTP.', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is LoginOnHold) {
            Navigator.of(context).pop();
            final _snackBar = snackBar(
                'Your account on holding contact with owner!!',
                Icons.warning,
                Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is LoginTimeout) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Time out exception', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is LoginInternetError) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Internet connection failed.', Icons.wifi, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Slip',
                                style: black35Medium,
                              ),
                              Image.asset(
                                "assets/images/logo.PNG",
                                width: 50,height: 50,
                              ),
                              Text(
                                'Buddy',
                                style: black35Medium,
                              ),
                            ],
                          ),

                          Text(
                            'Your Health, Just a Click Away',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h,),
                      Text(
                        'Sign In \nwith Your Mobile',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Text(
                        'Enter your mobile number to receive a one-time\npassword (OTP) for secure login',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 30.h,),
                    /*  Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child: GestureDetector(
                          onTap: (){
                            debugPrint('Hit google in btn');
                            _handleGoogleSignIn(context).whenComplete(()  =>
                                _auth.authStateChanges().listen((event) {
                                  _user = event;
                                  if (_user != null) {
                                    debugPrint('Apple sign in');
                                    debugPrint('------------------');
                                    debugPrint(_user!.displayName ?? "");
                                    debugPrint(_user.toString() ?? "");
                                    debugPrint(_user!.email ?? "");
                                    debugPrint(_user!.uid ?? "");
                                    debugPrint(_user!.phoneNumber ?? "");
                                    debugPrint(_user!.photoURL ?? "");
                                    debugPrint(_user!.uid);
                                    debugPrint(_user!.emailVerified.toString() ?? '');
                                    debugPrint('---------------------');
                                  }
                                 // provider.authSocialRegisterData(context, _user!.displayName!, _user!.email!, _user!.displayName!, passController.text,"google");
                                }));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/google.png",height: 25,width: 25,),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Continue with Google',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        ,
                      ),
                      SizedBox(height: 30.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(color: Colors.black,height: 1,width: 50.w,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'or continue with mobile number',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(color: Colors.black,height: 1,width: 50.w,)
                        ],
                      ),
                      SizedBox(height: 50.h,),*/
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value){

                        },
                        validator: (text) {
                          if(text == null || text.isEmpty){
                            return 'please enter phone number';
                          }
                          return null;
                        },
                        controller: phoneController,
                        style: MyStyles.black12Light,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Mobile Number', // Optional hint inside the field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      GestureDetector(
                        onTap: (){
                          var map = {"Phone": phoneController.text.trim(),"Role":"User"};
                          print('send data ======>$map');
                          if (formkey.currentState!.validate()) {
                            loginCubit.getOtp(map);
                          }
                      /*    Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Otp(time: 120,),
                                ctx: context),
                                (route) => false,
                          );*/
                        },
                        child: Container(
                          height: 50.h,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: AppTheme.statusBar,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Continue',
                                style: MyStyles.black16Medium,
                              ),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView); // Use external browser
    } else {
      throw 'Could not launch $url';
    }
  }
}
