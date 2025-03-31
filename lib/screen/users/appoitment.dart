import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/constants/helpers.dart';
import 'package:slipbuddy/controller/schudle/schudle_cubit.dart';
import 'package:slipbuddy/screen/users/dashboard.dart';
import 'package:slipbuddy/webviewpage.dart';

class AppointmentScreen extends StatefulWidget {
  final String date;
  final String time;
  final int doctorId;
  final int HospitalID;
  final String profile;
  final String name;
  final String location;
   AppointmentScreen({super.key,required this.date,required this.time,required this.doctorId,required this.HospitalID,required this.profile,required this.name,required this.location});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late SchudleCubit otpCubit;

  final formkey = GlobalKey<FormState>();

  late BuildContext buildContext;

  initCubit(){
    otpCubit = context.read<SchudleCubit>();
  }
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: Text(
          "Book In-Clinic Appointment",
          style: GoogleFonts.roboto(
            color: AppTheme.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // You can use any icon here
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),

      body: BlocListener<SchudleCubit, SchudleState>(
        listener: (context, state) {
          if (state is SchudleLoading) {
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
          } else if (state is SchudleSuccess) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Dashboard(),
                  ctx: context),
            );
          } else if (state is SchudleResendSuccess) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Schudle sent successfully', Icons.done, Colors.green);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is SchudleFailed) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Failed to send an Schudle.', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is SchudleOnHold) {
            Navigator.of(context).pop();
            final _snackBar = snackBar(
                'Your account on holding contact with owner!!',
                Icons.warning,
                Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is SchudleTimeout) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Time out exception', Icons.warning, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          } else if (state is SchudleInternetError) {
            Navigator.of(context).pop();
            final _snackBar =
            snackBar('Internet connection failed.', Icons.wifi, Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.profile),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Oral And Maxillofacial Surgeon",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Icon(Icons.thumb_up, color: Colors.green, size: 16),
                            Text(" 100%"),
                            SizedBox(width: 10),
                            Icon(Icons.comment, color: Colors.green, size: 16),
                            Text(" 18 Patient Stories"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),

              // Appointment Time Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5.0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time,size: 15,),
                        SizedBox(width: 5),
                        Text("Appointment time",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('${Helpers.dateformat(widget.date)} ${Helpers.formatTime(widget.time)}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                        Container(height: 15,width: 1,color: Colors.black,margin: EdgeInsets.symmetric(horizontal: 5.0),),
                        Row(
                          children: [
                            Icon(Icons.access_time,size: 15,),
                            SizedBox(width: 5),
                            Text("in 16 hours 30 minutes",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),

              // Clinic Details Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time,size: 15,),
                        SizedBox(width: 5),
                        Text("Clinic Details",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.location,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.purple),
                        SizedBox(width: 5),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Slip Buddy Promise -', // सामान्य टेक्स्ट
                              style: TextStyle(color: Colors.purple, fontSize: 12,fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Appointment confirmed instantly', // क्लिकेबल टेक्स्ट
                                  style: TextStyle(
                                      fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: WebViewPage(url: 'https://slipbuddy.com/policy',),
                                            ctx: context),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),

              // Apply Coupon Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon Container
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        // Text Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Apply Coupon",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Unlock offers with coupon codes",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Apply Button
                        Text(
                          "APPLY",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(),
              Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bill Details Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bill Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Consultation Fee"),
                        Text("₹600"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Service Fee & Tax"),
                            Text(
                              "We care for you & provide a free booking",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₹49 FREE",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Payable",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹600",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          "You have saved ₹49 on this appointment",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Practo Promise Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Practo Promise",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.purple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Appointment confirmed instantly with the doctor.",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.purple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "We assure we will connect you to the doctor. If your consultation does not happen for unforeseen reasons, we will give you 100% money back.",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.purple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "24/7 live chat support to address all your queries.",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Safety Measures Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Safe VISIT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Safety measures followed by Clinic:"),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Mask Mandatory"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Temperature check at entrance"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Sanitization of the visitors"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Social distance maintained"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // WhatsApp Notification Section
              Row(
                children: [
                  Icon(Icons.wallet, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Get notification on WhatsApp"),
                ],
              ),
              Text(
                "* Updates will be sent to +91xxxxxxxxxx.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
              Divider(),
              // Bill Details Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    RichText(
                      text: TextSpan(
                        text: 'By booking the appointment,you agree to Slip Buddy ', // सामान्य टेक्स्ट
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms and Conditions', // क्लिकेबल टेक्स्ट
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: WebViewPage(url: 'https://slipbuddy.com/policy',),
                                      ctx: context),
                                );
                              },
                          ),
                          TextSpan(
                            text: ' You can also Pre-pay for this appointment by selecting Pay online option ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0, // Set the width (same as height for a perfect circle)
                              height: 50.0, // Set the height
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.black, // Background color of the circle
                                shape: BoxShape.circle, // Makes the container a circle
                              ),
                              child: Center(
                                child: Text(
                                  "A", // Optional content inside the circle
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("In-Clinic Appointment for",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10),),
                                Text(
                                  "Ram Saini",
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,),
                                )
                              ],
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle view bill
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Removes extra padding
                            minimumSize: Size(0, 0), // Ensures no minimum size constraints
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap target size
                          ),
                          child: Text(
                            "CHANGE",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: [
                    // Price Section with 20% width
                    Expanded(
                      flex: 2, // 20% of total width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("₹300",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                          TextButton(
                            onPressed: () {
                              // Handle view bill
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // Removes extra padding
                              minimumSize: Size(0, 0), // Ensures no minimum size constraints
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap target size
                            ),
                            child: Text(
                              "View Bill",
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the two sections
                    // Confirm Clinic Visit Button with 80% width
                    Expanded(
                      flex: 8, // 80% of total width
                      child: commonButton(
                        color: AppTheme.statusBar,
                        text: 'Confirm Clinic Visit',
                        button: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String userToken = prefs.getString('user_id') ?? '';
                          var map = {
                            "Id": "0",
                            "RegistrationNumber": "123456",
                            "HospitalId": widget.HospitalID,
                            "AppointmentDate": Helpers.dateformat1(widget.date),
                            "Pname": "Mr. Shankar Lal",
                            "Age": "44",
                            "DOB": "2024-09-17",
                            "Gender": "Male",
                            "ConsultDr": widget.doctorId,
                            "Mobile": "1234567890",
                            "Email": "shekhar#gmail.com",
                            "CareType": "S/O",
                            "careName": "0",
                            "Pcat": "1",
                            "Address": widget.location,
                            "CountryId": "0",
                            "StateId": "0",
                            "CityId": "0",
                            "CityName": "Jaipur",
                            "Zip": "302018",
                            "PaymentMode": "1",
                            "MsrNo": userToken,
                            "IsOnline": "1",
                            "TimeSlot": widget.time
                          };
                          print('map value-------$map');
                          otpCubit.verifyOtp(map);
                        },
                        borderRadius: 5.0,
                      ),
                    ),
                  ],
                ),
              )

              // Confirm Clinic Visit Button

            ],
          ),
        ),
      )
      ,
    );
  }
}
