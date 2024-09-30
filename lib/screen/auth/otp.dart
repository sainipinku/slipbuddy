import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/my_styles.dart';
import 'package:slipbuddy/controller/otp_auth/otp_cubit.dart';
import 'package:slipbuddy/screen/dashboard/home_screen.dart';
import 'package:slipbuddy/screen/users/dashboard.dart';


class Otp extends StatefulWidget {
  late  int time;
  final String phone;
   Otp({super.key,required this.time,required this.phone});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late OtpCubit otpCubit;
  final formkey = GlobalKey<FormState>();
  late BuildContext buildContext;
  initCubit(){
    otpCubit = context.read<OtpCubit>();
  }
  bool light = true;
  final TextEditingController _pinPutController = TextEditingController();
  Timer? _timer;
  bool resend = false;
  formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
  void startTimer() {
    setState(() {
      resend = false;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (widget.time == 0) {
          setState(() {
            _pinPutController.text='';
            resend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            widget.time--;
          });
        }
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    initCubit();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer!.cancel();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );
    return  Scaffold(
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
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpLoading) {
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
          } else if (state is OtpSuccess) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Dashboard(),
                  ctx: context),
            );
          } else if (state is OtpResendSuccess) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Otp sent successfully', Icons.done, Colors.green);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is OtpFailed) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Failed to send an OTP.', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is OtpOnHold) {
            Navigator.of(context).pop();
            final _snackBar = snackBar(
                'Your account on holding contact with owner!!',
                Icons.warning,
                Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is OtpTimeout) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Time out exception', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is OtpInternetError) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Internet connection failed.', Icons.wifi, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          }
        },
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h,),
                  Text(
                    'Slip Buddy',
                    style: MyStyles.black35Medium,
                  ),
                  SizedBox(height: 40.h,),
                  Text(
                    'Verify mobile number',
                    style: MyStyles.black25bold,
                  ),
                  SizedBox(height: 10.h,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'We have sent the OTP to +91 ${widget.phone}',
                      style: MyStyles.blu14bold,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                      color: Colors.transparent,
                      child: PinCodeTextField(
                        appContext: context,
                        textStyle: MyStyles.black14Light,
                        length: 6,
                        controller: _pinPutController,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(25),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            borderWidth: 0.5,
                            activeFillColor: Colors.grey,
                            inactiveColor: AppTheme.whiteColor,
                            inactiveFillColor: Colors.grey,
                            selectedFillColor: Colors.grey,
                            selectedColor: AppTheme.bgColor,
                            activeColor: AppTheme.blackColor),
                        cursorColor: AppTheme.blackColor,
                        enableActiveFill: true,
                        // controller: provider.pinPutController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {

                        },
                      )),
                  GestureDetector(
                    onTap: (){
                      if(resend){
                        startTimer();
                      }else{

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        resend == false ?
                        "${"Resend OTP in "+ formatedTime(timeInSecond: widget.time)} Seconds" : "Resend OTP",
                        textAlign: TextAlign.center,
                        style: MyStyles.black16Bold,),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                     if(_pinPutController.text.isNotEmpty){
                       var map = {"Phone": widget.phone,"OTP":_pinPutController.text.trim()};
                       otpCubit.verifyOtp(map);
                     }else {

                     }
                    },
                    child: Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Verify & Login',
                          style: MyStyles.white22ExtraBold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stay information with regular updates on \nWhatsApp!',
                          style: MyStyles.black14Light,
                        ),
                        Switch(
                          // This bool value toggles the switch.
                          value: light,
                          overlayColor: overlayColor,
                          trackColor: trackColor,
                          thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              light = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'By Logging in you agree to the following',
                      style: MyStyles.black16Light,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Terms of use ',
                      style: MyStyles.blu14bold,
                      children:  <TextSpan>[
                        TextSpan(text: ' and ' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        TextSpan(text: ' Privacy Policy',style: MyStyles.blu14bold),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Copyright @ 2024 \n www.silpbuddy.com All Right Reserved',textAlign: TextAlign.center,
                      style: MyStyles.black16Light,
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  RichText(
                    text: TextSpan(
                      text: 'Disclaimer',
                      style: MyStyles.blu14bold,
                      children:  <TextSpan>[
                        TextSpan(text: '   Privacy Policy  ' , style :MyStyles.blu14bold),
                        TextSpan(text: 'Terms of use',style: MyStyles.blu14bold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      )
      ,
    );
  }
}
