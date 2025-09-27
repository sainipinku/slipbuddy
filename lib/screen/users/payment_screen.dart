import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/controller/appointment/appointment_cubit.dart';
import 'package:slipbuddy/models/AppointmentModel.dart';

import '../../Widgets/CommonAppBar.dart';
import '../../constants/app_theme.dart';
class PaymentScreen extends StatefulWidget {


  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late AppointmentCubit appointmentCubit;

  void initCubit()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    var body = {"msrno" : userToken};
    appointmentCubit = context.read<AppointmentCubit>();
    appointmentCubit.fetchAppointment(body);
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
      appBar: CommonAppBar(
        title: 'Payment',
        backgroundColor: AppTheme.statusBar,
        actions: [
          // Icon(Icons.search),
        ],
      ),
      body: MultiBlocListener(
          listeners: [
            BlocListener<AppointmentCubit,AppointmentState>(listener: (context,state){
              if (state is AppointmentLoading) {
                /*   showDialog(
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
              } else if (state is AppointmentLoaded) {
                // Navigator.of(context).pop();


              } else if (state is AppointmentFailed) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is AppointmentTimeout) {
                // Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is AppointmentInternetError) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is AppointmentLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            })
          ],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: BlocBuilder<AppointmentCubit,AppointmentState>(builder: (context,state){
              if (state is AppointmentLoaded) {
                int itemCount = state.appointmentList.length;
                String formattedDateTime = '';
                return itemCount != 0 ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment History',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,color: Colors.black
                      ),
                    ),
                    SizedBox(height: 20),
                    ...state.appointmentList.map((payment) => PaymentCard(payment)).toList(),
                  ],
                ) : Center(child: Text('No Record Found'));
              } else {
                return const Center(child: Text('Loading......'));
              }
            }),
          )),
    );
  }
}

class PaymentCard extends StatelessWidget {

  final AppointmentModel payment;
  String formattedDateTime = '';
  PaymentCard(this.payment);

  @override
  Widget build(BuildContext context) {
    bool isPaid = payment.status == 'Paid';
    String? appointmentDate = payment.appointmentDate;
    String? timeSlot = payment.timeSlot;

    // Parse the date and time
    DateTime parsedDate = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(
        appointmentDate!);
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(timeSlot!);

    // Combine date and time
    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Format the DateTime
    formattedDateTime = DateFormat("MMM dd, h:mm a").format(combinedDateTime);
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.drName!,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  payment.hospitalName!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  formattedDateTime,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.Fees.toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green[700] : Colors.red[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPaid ? 'Paid' : 'Pending',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}