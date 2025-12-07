import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
import 'package:slipbuddy/controller/appointment_promise/promise_cubit.dart';
import 'package:slipbuddy/controller/schudle/schudle_cubit.dart';
import 'package:slipbuddy/payment/PaymentFailedScreen.dart';
import 'package:slipbuddy/payment/PaymentSuccessScreen.dart';
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
  AppointmentScreen(
      {super.key,
      required this.date,
      required this.time,
      required this.doctorId,
      required this.HospitalID,
      required this.profile,
      required this.name,
      required this.location});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String totalAmount = '1';
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
  late PromiseCubit promiseCubit;
  late DoctorScheduleDetailsCubit doctorScheduleDetailsCubit;
  String _paymentMethod = "clinic";
  final formkey = GlobalKey<FormState>();
  late Razorpay _razorpay;
  late BuildContext buildContext;
  bool isChecked = false;
  initCubit() {
    otpCubit = context.read<SchudleCubit>();
    promiseCubit = context.read<PromiseCubit>();
    doctorScheduleDetailsCubit = context.read<DoctorScheduleDetailsCubit>();
    var body = {"doctorid": widget.doctorId.toString()};
    doctorScheduleDetailsCubit.fetchDoctorScheduleDetails(body);
    promiseCubit.promiseList();
  }

  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    getData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  String name = '';
  String email = '';
  String phone = '';
  Map? map;
  // Function to get data from SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_first_name') ??
          ''; // Default to an empty string if null
      email = prefs.getString('user_email') ?? '';
      phone = prefs.getString('user_phone') ?? '';
      patientName = name;
      context.read<PatientBloc>().add(UpdatePatientName(name));
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle success
    print('map value-------$map');
    map!.addAll({
      "TranstionID": "${response.paymentId}",
      "OrderStatus": "Success",
    });
    otpCubit.verifyOtp(map!,'success');
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: PaymentSuccessScreen(
            paymentId: response.paymentId.toString(),
          ),
          ctx: context),
    );
    print("SUCCESS: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    map!.addAll({
      "TranstionID": "",
      "OrderStatus": "Fail",
    });
    otpCubit.verifyOtp(map!,'fail');
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: PaymentFailedScreen(
            message: response.message.toString(),
          ),
          ctx: context),
    );
    // Handle failure
    print("ERROR: ${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle wallet
    print("WALLET: ${response.walletName}");
  }

  void openCheckout(String amount, String orderId) {
    int finalAmount = (num.parse(amount.toString()).round() * 100);
    print('final amount----------------$finalAmount');
    var options = {
      'key': 'rzp_live_tYeGRPBIWI3JSG',
      'amount': finalAmount, // in paise = ₹500
      'name': 'Slip Buddy',
      'currency': 'INR',
      'description': 'Payment for Order',
      'order_id': orderId, // ✅ Pass Razorpay order_id here
      'prefill': {'contact': '7412013030', 'email': 'slipbuddy2022@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    print('options------------------>$options');
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  String generateSixDigitId() {
    final random = Random();
    int id = 100000 + random.nextInt(900000);
    return 'ORD$id'; // e.g., ORD482193
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes event listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: Text(
          "Book In-Clinic Appointment",
          style: GoogleFonts.poppins(
            color: AppTheme.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // You can use any icon here
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: MultiBlocListener(
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
                  if (_paymentMethod == "online") {
                    openCheckout(totalAmount, state.appointment.orderNo!);
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Dashboard(),
                          ctx: context),
                    );
                  }
                } else if (state is SchudleResendSuccess) {
                  Navigator.of(context).pop();
                } else if (state is PaymentSuccess) {
                  Navigator.of(context).pop();
                }else if (state is PaymentFail) {
                  Navigator.of(context).pop();
                }
                else if (state is SchudleFailed) {
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
                  final _snackBar = snackBar(
                      'Internet connection failed.', Icons.wifi, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              },
            ),
            BlocListener<DoctorScheduleDetailsCubit,
                DoctorScheduleDetailsState>(
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
                  final _snackBar = snackBar(
                      'Token has been expired', Icons.done, Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              },
            ),
          ],
          child: BlocBuilder<DoctorScheduleDetailsCubit,
              DoctorScheduleDetailsState>(
            builder: (context, state) {
              if (state is DoctorScheduleDetailsLoaded) {
                // Set the max item count to 6 or less, plus 1 if there are more than 6 items for the 'More' button
                var itemValue = state.DoctorScheduleDetailsList;

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
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(itemValue[0].profilePic!),
                                ),
                                Container(
                                  height: 25,
                                  width: 50,
                                  color: AppTheme.statusappBar,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.home, size: 16),
                                      Expanded(
                                        child: Text(
                                          'In Clinic',
                                          style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemValue[0].fullName!,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        itemValue[0].description!,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '| ${itemValue[0].experience!} Years Experience',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    itemValue[0].location!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  /*  Row(
                                    children: [
                                      Icon(Icons.thumb_up, color: Colors.green, size: 16),
                                      Text(itemValue[0].thumsup!,style: GoogleFonts.poppins(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)),
                                      SizedBox(width: 10),
                                      Icon(Icons.comment, color: Colors.green, size: 16),
                                      Text(itemValue[0].noOfStories!,style: GoogleFonts.poppins(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)),
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        height: 5,
                        color: Colors.black12,
                        thickness: 2,
                      ),

                      // Appointment Time Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Appointment time",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
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
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  height: 15,
                                  width: 1,
                                  color: Colors.black,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 16),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          itemValue[0].nextAvailable != null
                                              ? itemValue[0].nextAvailable!
                                              : 'N/A',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      Divider(
                        height: 5,
                        color: Colors.black12,
                        thickness: 2,
                      ),

                      // Clinic Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Clinic Details",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.location,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                        color: Colors.black12,
                        thickness: 4,
                      ),
                      // Apply Coupon Section
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.statusBar),
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
                                    color: Colors
                                        .white, // ✅ use Colors.white, not Color.white
                                    shape: BoxShape.circle,
                                  ),
                                  padding:
                                      EdgeInsets.all(3), // optional padding
                                  child: Image.asset(
                                    'assets/images/copan1.png',
                                  ),
                                ),
                                SizedBox(width: 15),
                                // Text Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Apply Coupon",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Unlock offers with coupon codes",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Apply Button
                                Text(
                                  "APPLY",
                                  style: GoogleFonts.poppins(
                                    color: AppTheme.statusBar,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

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
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Consultation Fee"),
                                      Text(itemValue[0].fees!),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Discount Applied"),
                                          Text(
                                            "Instant ₹${itemValue[0].coupenAmount ?? ''} OFF applied via Slip Buddy",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '₹${itemValue[0].coupenAmount ?? ''}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.grey,
                                          decorationThickness: 2,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Divider(
                                      height: 5,
                                      color: Colors.black12,
                                      thickness: 2,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Payable",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        itemValue[0].NetFees!,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.billpayText,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        border:
                                            Border.all(color: Colors.green)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "You saved ₹${itemValue[0].coupenAmount ?? ''} on this booking with Slip Buddy",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Image.asset(
                                            'assets/images/save.png',
                                            width: 24, // adjust size as needed
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.statusappBar),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: AppTheme.statusappBarBg,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: AppTheme.statusappBar),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppTheme.statusappBar),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                  size: 15,
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              itemValue[0].promiseHeading!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.blackColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  BlocConsumer<PromiseCubit, PromiseState>(
                                    listener: (context, state) {
                                      if (state is PromiseTimeout) {
                                        final _snackBar = snackBar(
                                            'Time out exception',
                                            Icons.warning,
                                            Colors.red);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(_snackBar);
                                      } else if (state is PromiseInternetError) {
                                        final _snackBar = snackBar(
                                            'Internet connection failed.',
                                            Icons.wifi,
                                            Colors.red);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(_snackBar);
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is DoctorScheduleDetailsLoading) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is PromiseSuccess) {
                                        final itemValue = state
                                            .appointmentPromiseList; // assuming your loaded data
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: List.generate(
                                                itemValue.length, (index) {
                                              final promise = itemValue[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.check,
                                                        color:
                                                        AppTheme.blackColor),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            promise.heading ?? '',
                                                            textAlign:
                                                            TextAlign.justify,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              color:
                                                              AppTheme.blackColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            promise.description ?? '',
                                                            textAlign:
                                                            TextAlign.justify,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color:
                                                              AppTheme.blackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        );
                                      } else if (state
                                      is DoctorScheduleDetailsFailed) {
                                        return Center(
                                            child: Text('Failed to load promises'));
                                      } else {
                                        return SizedBox();
                                      }
                                    },
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: AppTheme.whiteColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // important to shrink-wrap content
                                      children: [
                                        Icon(
                                          Icons.verified_user,
                                          color: AppTheme.statusappBar,
                                          size: 15,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Safe VISIT",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Safety measures followed by Clinic:",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      Text(itemValue[0].safty1!,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      Text(itemValue[0].safty2!,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      Text(itemValue[0].safty3!,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      Text(itemValue[0].safty4!,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(
                                height: 5,
                                color: Colors.black12,
                                thickness: 2,
                              ),
                            ),
                            // WhatsApp Notification Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Get notification on WhatsApp",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "* Updates will be sent to $phone",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Bill Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    'By booking the appointment,you agree to Slip Buddy ', // सामान्य टेक्स्ट
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'Terms and Conditions', // क्लिकेबल टेक्स्ट
                                    style: GoogleFonts.poppins(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: WebViewPage(
                                                url:
                                                    'https://slipbuddy.com/policy',
                                              ),
                                              ctx: context),
                                        );
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        ' You can also Pre-pay for this appointment by selecting Pay online option ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(
                                height: 5,
                                color: Colors.black12,
                                thickness: 2,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width:
                                          50.0, // Set the width (same as height for a perfect circle)
                                      height: 50.0, // Set the height
                                      margin: EdgeInsets.only(right: 5.0),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .statusBar, // Background color of the circle
                                        shape: BoxShape
                                            .circle, // Makes the container a circle
                                      ),
                                      child: Center(
                                        child: Text(
                                          "A", // Optional content inside the circle
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "In-Clinic Appointment for",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10),
                                        ),
                                        BlocBuilder<PatientBloc, PatientState>(
                                          builder: (context, state) {
                                            return Text(
                                              state.patientName,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
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
                                    showSelectPatientBottomSheet(
                                        context, name, phone);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets
                                        .zero, // Removes extra padding
                                    minimumSize: Size(0,
                                        0), // Ensures no minimum size constraints
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // Reduces tap target size
                                  ),
                                  child: Text(
                                    "CHANGE",
                                    style: GoogleFonts.poppins(
                                        color: AppTheme.statusBar,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      RadioListTile(
                        activeColor: AppTheme.statusBar,
                        title: Text(
                          "Pay at Clinic (Offline)",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Pay directly at the clinic during your visit.",
                          style: GoogleFonts.poppins(),
                        ),
                        value: "clinic",
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: AppTheme.statusBar,
                        title: Text(
                          "Pay Online (UPI / Card / Wallet)",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Pay now and skip the queue.",
                          style: GoogleFonts.poppins(),
                        ),
                        value: "online",
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(
                          height: 5,
                          color: Colors.black12,
                          thickness: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          children: [
                            // Price Section with 20% width
                            Expanded(
                              flex: 3, // 20% of total width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(itemValue[0].NetFees!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextButton(
                                    onPressed: _scrollToBillDetails,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets
                                          .zero, // Removes extra padding
                                      minimumSize: Size(0,
                                          0), // Ensures no minimum size constraints
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // Reduces tap target size
                                    ),
                                    child: Text(
                                      "View Bill",
                                      style: GoogleFonts.poppins(
                                          color: AppTheme.statusBar,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    10), // Add some spacing between the two sections
                            // Confirm Clinic Visit Button with 80% width
                            Expanded(
                              flex: 7, // 80% of total width
                              child: commonButton(
                                color: AppTheme.statusBar,
                                text: 'Confirm Appointment',
                                button: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String userToken =
                                      prefs.getString('user_id') ?? '';
                                  map = {
                                    "Id": "0",
                                    "RegistrationNumber": "123456",
                                    "HospitalId": widget.HospitalID,
                                    "AppointmentDate":
                                        Helpers.dateformat1(widget.date),
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
                                    "PaymentMode":
                                        _paymentMethod == "clinic" ? "0" : "1",
                                    "MsrNo": userToken,
                                    "IsOnline": "1",
                                    "TimeSlot": widget.time,
                                    "OrderID": generateSixDigitId(),
                                  };
                                  otpCubit.verifyOtp(map!,'payment');
                                  setState(() {
                                    totalAmount = itemValue[0].NetFees!;
                                  });
                                },
                                borderRadius: 5.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              10), // Add some spacing between the two sections

                      // Confirm Clinic Visit Button
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No Announcement Found'));
              }
            },
          ),
        ),
      ),
    );
  }

  String getInTimeMinutes(String timeStr) {
    print('time-----------$timeStr');
    try {
      // Parse "HH:mm"
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      var target = DateTime(now.year, now.month, now.day, hour, minute);

      // If target time already passed today, move to next day
      if (target.isBefore(now)) {
        target = target.add(Duration(days: 1));
      }

      final diff = target.difference(now);

      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);

      if (hours > 0) {
        return 'in $hours hours $minutes minutes';
      } else {
        return 'in $minutes minutes';
      }
    } catch (e) {
      print("Time parse error: $e");
      return "Invalid time";
    }
  }
}

void showPatientDetailsBottomSheet(
    BuildContext context, String name, String phone, String type) {
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController patientPhonetextEditingController =
      TextEditingController();
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
          builder: (BuildContext context, StateSetter setState) {
        var genderValue;
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
                        style: GoogleFonts.poppins(
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
                SizedBox(height: 10),
                TextField(
                  controller: emailtextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Patient's Age",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Patient's Gender*",
                    border: OutlineInputBorder(),
                  ),
                  value: genderValue,
                  items: ["Male", "Female", "Other"].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      genderValue = newValue!;
                    });
                  },
                ),
                if (type == 'new') SizedBox(height: 10),
                if (type == 'new')
                  TextField(
                    controller: phonetextEditingController,
                    keyboardType: TextInputType.phone,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Patient's Mobile*",
                      border: OutlineInputBorder(),
                    ),
                  ),
                /*  SizedBox(height: 10),
                  TextField(
                    controller: patientPhonetextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Patient's Mobile*",
                      border: OutlineInputBorder(),
                    ),
                  ),*/

                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppTheme.statusBar,
                  ),
                  onPressed: () {
                    setState(() {
                      patientName = nametextEditingController.text;
                      patientAge = emailtextEditingController.text;
                    });
                    Navigator.pop(context); // Or perform submit logic
                    context
                        .read<PatientBloc>()
                        .add(UpdatePatientName(nametextEditingController.text));
                  },
                  child: Text("Confirm"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      });
    },
  );
}

void showSelectPatientBottomSheet(
    BuildContext context, String name, String phone) {
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
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
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
                Divider(
                  height: 5,
                  color: Colors.black12,
                  thickness: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Edit logic here
                          Navigator.pop(context); // Or perform submit logic
                          showPatientDetailsBottomSheet(
                              context, name, phone, 'edit');
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
              showPatientDetailsBottomSheet(context, name, phone, 'new');
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
