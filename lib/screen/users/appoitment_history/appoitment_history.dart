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
              final _snackBar = snackBar(
                  'Status update successfully', Icons.done, Colors.green);
              ScaffoldMessenger.of(context).showSnackBar(_snackBar);

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

          return ListView.builder(
            itemCount: itemCount, // Total number of items
            itemBuilder: (context, index) {
              var item = state.appointmentList[index];
              String appointmentDate = item.appointmentDate!;
              String timeSlot = item.timeSlot!;

              // Parse the date and time
              DateTime parsedDate = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(appointmentDate);
              DateTime parsedTime = DateFormat("HH:mm:ss").parse(timeSlot);

              // Combine date and time
              DateTime combinedDateTime = DateTime(
                parsedDate.year,
                parsedDate.month,
                parsedDate.day,
                parsedTime.hour,
                parsedTime.minute,
              );

              // Format the DateTime
              String formattedDateTime = DateFormat("MMM dd, h:mm a").format(combinedDateTime);
              return AppointmentCard(
                dateTime: formattedDateTime,
                title: item.department!,
                doctorName: item.drName!,
                clinic: item.hospitalAddress!,
                imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URL
                status: 'Booked',
                actionText: 'View Details',
                actionColor: Colors.blue,
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
  final String clinic;
  final String imageUrl;
  final String status;
  final String actionText;
  final Color actionColor;
  final bool isCancelled;

  const AppointmentCard({
    required this.dateTime,
    required this.title,
    required this.doctorName,
    required this.clinic,
    required this.imageUrl,
    required this.status,
    required this.actionText,
    required this.actionColor,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(10),
        color: isCancelled ? Colors.red[50] : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateTime,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        clinic,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            isCancelled
                ? Text(
              'Appointment Cancelled',
              style: TextStyle(fontSize: 16, color: Colors.red),
            )
                : Container(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor,
                  ),
                  child: Text(actionText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
