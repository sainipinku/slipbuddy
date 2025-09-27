import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/bottom_diloag/delete_accout.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/login_auth/login_cubit.dart';
import 'package:slipbuddy/screen/auth/login.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? selectedReason;
  late TextEditingController descriptionController = TextEditingController();
  final List<String> reasons = [
    'Find a Better Alternative',
    'Need a Break',
    'Do not find useful anymore',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Delete My Account',
        backgroundColor: AppTheme.statusBar,
        actions: [
          // Icon(Icons.search),
        ],
      ),
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
                  child: Login(),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By Delete your account',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '• All your sleep tracking and progress data\n'
                              '• All History related to sleep schedules, routines, and tips\n'
                              '• All your data from SleepBuddy will be permanently deleted',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Help us improve our app. Explain the reason why you want to delete your account',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,color: Colors.black26
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor:  Colors.white,
                              isExpanded: true,
                              hint:  Text(
                                '--Select--',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,color: Colors.black26
                                ),
                              ),
                              value: selectedReason,
                              items: reasons.map((String reason) {
                                return DropdownMenuItem<String>(
                                  value: reason,
                                  child: Text(reason, style:  GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,color: Colors.black26
                                  )),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedReason = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: selectedReason == 'Other',
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(
                                color: AppTheme.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintText: 'Write your message...',
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),

                        // Buttons

                      ],
                    ),
                  ),
                  Positioned(bottom: 0,left: 0,right: 0,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DeleteAccountBottomDilog(context,selectedReason!);
                          },
                          child: Text("Delete Your Account",style: GoogleFonts.poppins(
                              color: AppTheme.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: AppTheme.statusBar,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35), // <-- Rounded corners
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:  Text(
                            'No, Keep my account',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,color: Colors.black26
                            ),
                          ),
                        ),
                      ],
                    ),)
                ],
              ),
            ),
          ),
        ),
      )
      ,
    );
  }
}
