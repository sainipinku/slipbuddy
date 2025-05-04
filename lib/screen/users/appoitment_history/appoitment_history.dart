import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/appointment/appointment_cubit.dart';

class AppoitmentHistory extends StatefulWidget {
  @override
  State<AppoitmentHistory> createState() => _AppoitmentHistoryState();
}

class _AppoitmentHistoryState extends State<AppoitmentHistory> {
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

class AppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: BlocBuilder<AppointmentCubit,AppointmentState>(builder: (context,state){
        if (state is AppointmentLoaded) {
          int itemCount = state.appointmentList.length;
          String formattedDateTime = '';
          return ListView.builder(
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
          );
        } else {
          return const Center(child: Text('No Announcement Found'));
        }
      }),
    );
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
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
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
                    Text(dateTime, style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 5),
                    Text(
                      'In-Clinic Appointment, ${title}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(doctorName),
                    Text(clinic, style: TextStyle(color: Colors.grey)),
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
