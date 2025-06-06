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
import 'package:slipbuddy/controller/DoctorSchudleDetails/doctor_Schedule_Details_cubit.dart';
import 'package:slipbuddy/controller/appointment/PatientBloc.dart';
import 'package:slipbuddy/controller/appointment/PatientEvent.dart';
import 'package:slipbuddy/controller/appointment/PatientState.dart';
import 'package:slipbuddy/controller/schudle/schudle_cubit.dart';
import 'package:slipbuddy/screen/users/dashboard.dart';
import 'package:slipbuddy/webviewpage.dart';
String patientName = 'Ramchadra saini';
String patientAge = '29';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _billDetailsKey = GlobalKey();
  bool light = true;
  void _scrollToBillDetails() {
    Scrollable.ensureVisible(
      _billDetailsKey.currentContext!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  late SchudleCubit otpCubit;
  late DoctorScheduleDetailsCubit doctorScheduleDetailsCubit;

  final formkey = GlobalKey<FormState>();

  late BuildContext buildContext;

  initCubit(){
    otpCubit = context.read<SchudleCubit>();
    doctorScheduleDetailsCubit = context.read<DoctorScheduleDetailsCubit>();
    var body = {"doctorid": widget.doctorId.toString()};
    doctorScheduleDetailsCubit.fetchDoctorScheduleDetails(body);
  }
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    getData();
    super.initState();
  }
  String name = '';
  String email = '';
  String phone = '';

  // Function to get data from SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_first_name') ?? ''; // Default to an empty string if null
      email = prefs.getString('user_email') ?? '';
      phone = prefs.getString('user_phone') ?? '';
      patientName = name;
      context.read<PatientBloc>().add(UpdatePatientName(name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return AppTheme.statusBar;
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

      body: MultiBlocListener(
        listeners: [
          BlocListener<SchudleCubit, SchudleState>(
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

              } else if (state is SchudleFailed) {
                Navigator.of(context).pop();

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
          ),
          BlocListener<DoctorScheduleDetailsCubit, DoctorScheduleDetailsState>(
            listener: (context, state) {
              if (state is DoctorScheduleDetailsLoading) {
              /*  showDialog(
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
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              const Text('Loading...')
                            ],
                          ),
                        ),
                      );
                    });*/
              } else if (state is DoctorScheduleDetailsLoaded) {
                // Navigator.of(context).pop();


              } else if (state is DoctorScheduleDetailsFailed) {
                // Navigator.of(context).pop();
                            } else if (state is DoctorScheduleDetailsTimeout) {
                // Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is DoctorScheduleDetailsInternetError) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is DoctorScheduleDetailsLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            },
          ),
        ],
        child: BlocBuilder<DoctorScheduleDetailsCubit, DoctorScheduleDetailsState>(
          builder: (context, state) {
            if (state is DoctorScheduleDetailsLoaded) {
              // Set the max item count to 6 or less, plus 1 if there are more than 6 items for the 'More' button
              var itemValue = state.DoctorScheduleDetailsList;
              print('doctore details------------------${itemValue[0].profilePic}');
              return SingleChildScrollView(
                controller: _scrollController,
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
                            backgroundImage: NetworkImage(itemValue[0].profilePic!),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemValue[0].fullName!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                itemValue[0].description!,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.thumb_up, color: Colors.green, size: 16),
                                  Text(itemValue[0].thumsup!),
                                  SizedBox(width: 10),
                                  Icon(Icons.comment, color: Colors.green, size: 16),
                                  Text(itemValue[0].noOfStories!),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${Helpers.dateformat(widget.date)} ${Helpers.formatTime(widget.time)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                height: 15,
                                width: 1,
                                color: Colors.black,
                                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        itemValue[0].nextAvailable ?? 'N/A',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )

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
                                child: Image.asset('assets/images/copan.jpg',height: 20,width: 20,),
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
                            key: _billDetailsKey,
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
                                    Text(itemValue[0].fees!),
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
                                      itemValue[0].fees!,
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.purple),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height : 40,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade100,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.purple),child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.check, color: Colors.white,size: 15,),
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            itemValue[0].promiseHeading!,
                                            style: TextStyle(fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   children: [
                                     SizedBox(height: 10),
                                     Row(
                                       children: [
                                         Icon(Icons.check, color: Colors.purple),
                                         SizedBox(width: 8),
                                         Expanded(
                                           child: Text(
                                             itemValue[0].promiseText1!,textAlign: TextAlign.justify,
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
                                             itemValue[0].promiseText2!,textAlign: TextAlign.justify,
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
                                             itemValue[0].promiseText3!,textAlign: TextAlign.justify,
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
                                             itemValue[0].promiseText4!,textAlign: TextAlign.justify,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ],
                                 ),
                               )
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
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: AppTheme.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // important to shrink-wrap content
                                    children: [
                                      Icon(Icons.verified_user, color: AppTheme.statusBar),
                                      SizedBox(width: 4),
                                      Text(
                                        "Safe VISIT",
                                        style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.statusBar,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text("Safety measures followed by Clinic:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.fiber_manual_record, color: Colors.black,size: 15,),
                                    SizedBox(width: 8),
                                    Text(itemValue[0].safty1!,textAlign: TextAlign.justify,),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.fiber_manual_record, color: Colors.black,size: 15,),
                                    SizedBox(width: 8),
                                    Text(itemValue[0].safty2!,textAlign: TextAlign.justify,),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.fiber_manual_record, color: Colors.black,size: 15,),
                                    SizedBox(width: 8),
                                    Text(itemValue[0].safty3!,textAlign: TextAlign.justify,),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.fiber_manual_record, color: Colors.black,size: 15,),
                                    SizedBox(width: 8),
                                    Text(itemValue[0].safty4!,textAlign: TextAlign.justify,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // WhatsApp Notification Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.wallet, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text("Get notification on WhatsApp"),

                                    ],
                                  ),
                                  Text(
                                    "* Updates will be sent to $phone",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Switch(
                                // This bool value toggles the switch.
                                value: light,
                                overlayColor: overlayColor,
                                trackColor: trackColor,
                                thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    light = value;
                                  });
                                },
                              )
                            ],
                          )

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
                                      BlocBuilder<PatientBloc, PatientState>(
                                        builder: (context, state) {
                                          return Text(
                                            state.patientName,
                                            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,),
                                          );
                                        },
                                      )

                                    ],
                                  )
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle view bill
                                  showSelectPatientBottomSheet(context,name,phone);
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
                            flex: 3, // 20% of total width
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(itemValue[0].fees!,style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                                TextButton(
                                  onPressed: _scrollToBillDetails,
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
                            flex: 7, // 80% of total width
                            child: commonButton(
                              color: AppTheme.statusBar,
                              text: 'Confirm Appointment',
                              button: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String userToken = prefs.getString('user_id') ?? '';
                                var map = {
                                  "Id": "0",
                                  "RegistrationNumber": "123456",
                                  "HospitalId": widget.HospitalID,
                                  "AppointmentDate": Helpers.dateformat1(widget.date),
                                  "Pname": patientName,
                                  "Age": patientAge,
                                  "DOB": "2024-09-17",
                                  "Gender": "Male",
                                  "ConsultDr": widget.doctorId,
                                  "Mobile": "1234567890",
                                  "Email": email,
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
              );
            } else {
              return const Center(child: Text('No Announcement Found'));
            }
          },
        ),
      )
      ,
    );
  }
}
void showPatientDetailsBottomSheet(BuildContext context,String name,String phone,String type) {
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController patientPhonetextEditingController = TextEditingController();
  nametextEditingController.text = name;
  phonetextEditingController.text = phone;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // For full height
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder:  (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Text("Add Patient Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nametextEditingController,
                    decoration: InputDecoration(
                      labelText: "Patient's Full Name*",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if(type == 'new')
                  SizedBox(height: 10),
                  if(type == 'new')
                  TextField(
                    controller: phonetextEditingController,
                    keyboardType: TextInputType.phone,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Patient's Mobile*",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: patientPhonetextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Patient's Mobile*",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: emailtextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Patient's Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppTheme.statusBar,
                    ),
                    onPressed: () {

                      setState((){
                        patientName = nametextEditingController.text;
                        patientAge = emailtextEditingController.text;
                      });
                      Navigator.pop(context); // Or perform submit logic
                      context.read<PatientBloc>().add(UpdatePatientName(nametextEditingController.text));
                    },
                    child: Text("Confirm"),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      );
    },
  );
}

void showSelectPatientBottomSheet(BuildContext context,String name,String phone) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select a Patient",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Patient card
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text("R"),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Myself"),
                      Text(phone),
                    ],
                  ),
                ),
                Divider(height: 1),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Edit logic here
                          Navigator.pop(context); // Or perform submit logic
                          showPatientDetailsBottomSheet(context,name,phone,'edit');

                        },
                        child: Text("EDIT"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Select logic
                          Navigator.pop(context);
                          Navigator.pop(context); // Or perform submit logic
                        },
                        child: Text("SELECT"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          // Add new patient
          OutlinedButton(
            onPressed: () {
              // Add new patient logic here
              Navigator.pop(context); // Or perform submit logic
              showPatientDetailsBottomSheet(context,name,phone,'new');
            },
            child: Text("+ Add New Patient"),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    ),
  );
}
