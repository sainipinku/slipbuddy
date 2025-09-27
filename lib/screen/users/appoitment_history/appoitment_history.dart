import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/AppointmentStatus/appointmentstatus_cubit.dart';
import 'package:slipbuddy/controller/appointment/appointment_cubit.dart';
import 'package:slipbuddy/screen/users/ClinicVisitScreen.dart';

class AppoitmentHistory extends StatefulWidget {
  @override
  State<AppoitmentHistory> createState() => _AppoitmentHistoryState();
}

class _AppoitmentHistoryState extends State<AppoitmentHistory> {
  late AppointmentCubit appointmentCubit;
  Map body = {};
  void initCubit()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    body = {"msrno" : userToken};
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
    return MultiBlocListener(
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
          }),
          BlocListener<AppointmentStatusCubit,AppointmentStatusState>(listener: (context,state){
            if (state is AppointmentStatusLoading) {
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
            } else if (state is AppointmentStatusLoaded) {
              // Navigator.of(context).pop();
              appointmentCubit.fetchAppointment(body);

            } else if (state is AppointmentStatusFailed) {
              // Navigator.of(context).pop();
              final _snackBar = snackBar('Failed to update complain status.',
                  Icons.warning, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is AppointmentStatusTimeout) {
              // Navigator.of(context).pop();
              final _snackBar =
              snackBar('Time out exception', Icons.warning, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is AppointmentStatusInternetError) {
              // Navigator.of(context).pop();
              final _snackBar = snackBar(
                  'Internet connection failed.', Icons.wifi, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is AppointmentStatusLogout) {
              final _snackBar =
              snackBar('Token has been expired', Icons.done, Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            }
          })
        ],
        child: Scaffold(
          appBar: CommonAppBar(
            title: 'Appointment History',
            backgroundColor: AppTheme.statusBar,
            actions: [
              // Icon(Icons.search),
            ],
          ),
          body: AppointmentsTab(),
        ));
  }
}

class AppointmentsTab extends StatefulWidget {

  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  late AppointmentStatusCubit appointmentStatusCubit;

  void initCubit()async {
    appointmentStatusCubit = context.read<AppointmentStatusCubit>();
  }
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocBuilder<AppointmentCubit,AppointmentState>(builder: (context,state){
        if (state is AppointmentLoaded) {
          int itemCount = state.appointmentList.length;
          String formattedDateTime = '';
          return itemCount != 0 ? ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              var item = state.appointmentList[index];
              if(item.appointmentDate!.isNotEmpty && item.timeSlot!.isNotEmpty) {
                String? appointmentDate = item.appointmentDate;
                String? timeSlot = item.timeSlot;

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
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300, width: 1),
                      right: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.statusBar,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.status!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400, color: Colors.black
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Hospital name
                            Text(
                              item.hospitalName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                              ),
                            ),

                            // Doctor
                            Text(item.drName!, style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, color: Colors.black
                            ),),

                            // Appointment type and specialist
                            RichText(
                              text: TextSpan(
                                text: item.department!,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                ),
                                children: [
                                  TextSpan(
                                    text: item.department!,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black
                                    ),
                                  )
                                ],
                              ),
                            ),

                            // Location
                            Text(item.hospitalAddress!, style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, color: Colors.black
                            ),),
                            const SizedBox(height: 5),

                            // Date
                            Text(formattedDateTime, style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, color: Colors.black
                            ),),

                            // Token if available
                            if (item.TokenNo!.isNotEmpty)
                              Text("Token : ${item.TokenNo!}",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),),

                            const SizedBox(height: 10),

                            // Buttons

                          ],
                        ),
                      ),
                      item.status == 'Appointment Upcoming' ?
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ClinicVisitScreen(doctorId: item.DoctorID!,HospitalID: item.HospitalId!,profile: item.drPic!,name: item.drName!,location: item.hospitalAddress!,),
                                      ctx: context),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                side: BorderSide(
                                  color: Colors.grey, // 🔹 border color
                                  width: 1.2, // 🔹 border width
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Rescedule',
                                style: GoogleFonts.poppins(fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.0,),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Map body = {
                                  "Action": "Cancel",
                                  "Id": item.id,
                                  "CompleteStatus": "Cancel",
                                  "AppointmentDate": item.appointmentDate,
                                  "TimeSlot": item.timeSlot,
                                };
                                appointmentStatusCubit.fetchAppointmentStatus(body);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                side: BorderSide(
                                  color: Colors.grey, // 🔹 border color
                                  width: 1.2, // 🔹 border width
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                            ),
                          )
                        ],
                      ) : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ClinicVisitScreen(doctorId: item.DoctorID!,HospitalID: item.HospitalId!,profile: item.drPic!,name: item.drName!,location: item.hospitalAddress!,),
                                      ctx: context),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                side: BorderSide(
                                  color: Colors.grey, // 🔹 border color
                                  width: 1.2, // 🔹 border width
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Book Again',
                                style: GoogleFonts.poppins(fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.0,),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                side: BorderSide(
                                  color: Colors.grey, // 🔹 border color
                                  width: 1.2, // 🔹 border width
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'View Slip',
                                style: GoogleFonts.poppins(fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            },
          ) : Center(child: Text('No Record Found'));
        } else {
          return const Center(child: Text('Loading......'));
        }
      })
      ,
    );
      /*BlocBuilder<AppointmentCubit,AppointmentState>(builder: (context,state){
        if (state is AppointmentLoaded) {
          int itemCount = state.appointmentList.length;
          String formattedDateTime = '';
          return itemCount != 0 ? ListView.builder(
            itemCount: itemCount, // Total number of items
            itemBuilder: (context, index) {
              var item = state.appointmentList[index];
              if(item.appointmentDate!.isNotEmpty && item.timeSlot!.isNotEmpty){
                String? appointmentDate = item.appointmentDate;
                String? timeSlot = item.timeSlot;

                // Parse the date and time
                DateTime parsedDate = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(appointmentDate!);
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
              }
              return AppointmentCard(
                dateTime: formattedDateTime,
                title: item.department!,
                doctorName: item.drName!,
                patientName: item.patientName!,
                clinic: item.hospitalAddress!,
                imageUrl: item.drPic!, // Replace with actual image URL
                status: item.status!,
                actionText: 'View Details',
                actionColor: Colors.blue,
                token: item.TokenNo!,
              );
            },
          ): Center(child: Text('No Record Found'));
        } else {
          return const Center(child: Text('Loading......'));
        }
      })*/

  }
}

class AppointmentCard extends StatelessWidget {
  final String dateTime;
  final String title;
  final String doctorName;
  final String patientName;
  final String clinic;
  final String imageUrl;
  final String status;
  final String actionText;
  final Color actionColor;
  final bool isCancelled;
  final String token;
  const AppointmentCard({
    required this.dateTime,
    required this.title,
    required this.doctorName,
    required this.patientName,
    required this.clinic,
    required this.imageUrl,
    required this.status,
    required this.actionText,
    required this.actionColor,
    this.isCancelled = false,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String statusLabel;
    IconData iconData;

    switch (status) {
      case 'cancelled':
        bgColor = Colors.red.shade50;
        textColor = Colors.red;
        statusLabel = 'Appointment Cancelled';
        iconData = Icons.cancel;
        break;
      case 'InProcess':
        bgColor = Colors.yellow.shade50;
        textColor = Colors.orange;
        statusLabel = 'Appointment Pending';
        iconData = Icons.schedule;
        break;
      case 'completed':
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        statusLabel = 'Appointment Completed';
        iconData = Icons.check_circle;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.black;
        statusLabel = 'Unknown Status';
        iconData = Icons.help;
    }
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            color: bgColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Icon(iconData, color: textColor),
                  SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      dateTime,
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 5),
                    SizedBox(width: 250,
                      child: Text(
                        'In-Clinic Appointment, $title',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      doctorName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      clinic,
                      style: GoogleFonts.poppins(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),

                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 22,
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Token :  $token'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            child: Row(
              children: [
                Expanded(child: Text('Booked for $patientName')),
                if(status != 'InProcess')
                  OutlinedButton(
                    onPressed: () {
                      // Handle Book Again
                    },
                    child: Text('Book Again'),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}