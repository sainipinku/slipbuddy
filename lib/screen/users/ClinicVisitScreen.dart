import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';
import 'package:slipbuddy/constants/helpers.dart';
import 'package:slipbuddy/controller/slots/date_cubit.dart';
import 'package:slipbuddy/controller/slots/slots_cubit.dart';
import 'package:slipbuddy/models/SlotsModel.dart';
import 'package:slipbuddy/screen/users/appoitment.dart';

class ClinicVisitScreen extends StatefulWidget {
  final int doctorId;
  final String profile;
  final String name;
  final String location;
  const ClinicVisitScreen({super.key,required this.doctorId,required this.profile,required this.name,required this.location});
  @override
  _ClinicVisitScreenState createState() => _ClinicVisitScreenState();
}

class _ClinicVisitScreenState extends State<ClinicVisitScreen> {
  late SlotsCubit slotsCubit;
  late DateCubit dateCubit;
  initCubit() {
    // Get the current date formatted as "yyyy-MM-dd"
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var body1 = {"doctorid" : widget.doctorId};
    var body = {"doctorid" : widget.doctorId,"date":currentDate};
    slotsCubit = context.read<SlotsCubit>();
    dateCubit = context.read<DateCubit>();
    slotsCubit.fetchSlots(body);
    dateCubit.fetchDateSlots(body1);
    print("----------------------------------------------------");
  }

  @override
  void initState() {
    initCubit();
    super.initState();
  }
  int selectedIndex = 1; // Default selected date index
  final List<String> availableDates = [
    'Wed, 2 Oct',
    'Thu, 3 Oct',
    'Fri, 4 Oct',
  ];

  final List<String> morningSlots = ['10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'];
  final List<String> afternoonSlots = ['12:00 PM', '12:30 PM'];
  final List<String> eveningSlots = ['04:00 PM', '04:30 PM', '05:00 PM', '05:30 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 30, // Size of the circle
              child: ClipOval( // Ensures the image is clipped to a circle
                child: FadeInImage(
                  image: NetworkImage(widget.profile), // Network image from a URL
                  fit: BoxFit.cover, // Ensures the image covers the circle
                  placeholder: const AssetImage("assets/images/google.png"), // Placeholder image
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/google.png", // Fallback image if URL fails
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: TextStyle(fontSize: 16)),
                Text(widget.location, style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: AppTheme.statusBar,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back)),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SlotsCubit, SlotsState>(
              listener: (context, state) {
              /*  if (state is SlotsLoading) {
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
                      });
                } else*/ if (state is SlotsLoaded) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar(
                      'Status update successfully', Icons.done, Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);

                } else if (state is SlotsFailed) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar('Failed to update complain status.',
                      Icons.warning, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is SlotsTimeout) {
                  // Navigator.of(context).pop();
                  final _snackBar =
                  snackBar('Time out exception', Icons.warning, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is SlotsInternetError) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar(
                      'Internet connection failed.', Icons.wifi, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is SlotsLogout) {
                  final _snackBar =
                  snackBar('Token has been expired', Icons.done, Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              },
            ),
            BlocListener<DateCubit, DateState>(
              listener: (context, state) {
                if (state is DateLoading) {
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
                      });
                } else if (state is DateSlotsLoaded) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar(
                      'Status update successfully', Icons.done, Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);

                } else if (state is DateFailed) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar('Failed to update complain status.',
                      Icons.warning, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is DateTimeout) {
                  // Navigator.of(context).pop();
                  final _snackBar =
                  snackBar('Time out exception', Icons.warning, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is DateInternetError) {
                  // Navigator.of(context).pop();
                  final _snackBar = snackBar(
                      'Internet connection failed.', Icons.wifi, Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is DateLogout) {
                  final _snackBar =
                  snackBar('Token has been expired', Icons.done, Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clinic Visit Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              BlocBuilder<DateCubit, DateState>(builder: (context,state){
                if(state is DateSlotsLoaded) {
                  int itemCount = state.dateSlotsList.length;
                  var slots = state.dateSlotsList;
                  return Container(
                    height: 55, // Adjust height based on your need
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            var body = {"doctorid" : widget.doctorId,"date":Helpers.dateformat1(slots[index].date!)};
                            slotsCubit.fetchSlots(body);
                          },
                          child: Container(
                            width: 120, // Adjust width based on your need
                            margin: EdgeInsets.only(right: 10), // Add some spacing between items
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedIndex == index ? Colors.blue[100] : Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Helpers.dateformat(slots[index].date!), style: TextStyle(fontSize: 14)),
                                SizedBox(height: 2),
                                Text(slots[index].status!, style: TextStyle(fontSize: 12, color: slots[index].status! == 'Available' ? Colors.green : Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }else {
                  return const Center(child: Text('No Announcement Found'));
                }

              }),
              SizedBox(height: 20),
              Text('Thu, 3 Oct', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              BlocBuilder<SlotsCubit, SlotsState>(builder: (context,state){
                if (state is SlotsLoaded) {
                  int itemCount = state.SlotsList.length;
                  var slots = state.SlotsList;
                  print('slot data---------$slots');
                  // Arrays to store slots based on the period
                  List<String> morningSlots = [];
                  List<String> noonSlots = [];
                  List<String> eveningSlots = [];

                  // Loop through the list and categorize based on the 'Period' field
                  for (var slot in slots) {
                    if (slot.period == "Morning") {
                      morningSlots.add(slot.slotTime!);
                    } else if (slot.period == "Noon") {
                      noonSlots.add(slot.slotTime!);
                    } else if (slot.period == "Evening") {
                      eveningSlots.add(slot.slotTime!);
                    }
                  }

                  // Print the categorized arrays
                  print("Morning Slots: $morningSlots");
                  print("Noon Slots: $noonSlots");
                  print("Evening Slots: $eveningSlots");
                  return Column(
                    children: [
                      TimeSlotSection(
                        label: 'Morning',
                        slots: morningSlots,
                        icon: Icons.wb_sunny,
                      ),
                      TimeSlotSection(
                        label: 'Afternoon',
                        slots: noonSlots,
                        icon: Icons.wb_cloudy,
                      ),
                      TimeSlotSection(
                        label: 'Evening',
                        slots: eveningSlots,
                        icon: Icons.nights_stay,
                      ),
                    ],
                  );
                }else {
                  return const Center(child: Text('No Announcement Found'));
                }
              })
              ,
              Spacer(),
              // Bottom ad and button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: button(color: AppTheme.statusBar, text: 'CONSULT NOW', button: () {

                },borderRadius: 5.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add action to consult now
                    },
                    child: Text('CONSULT NOW'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        ,
      ),
    );
  }
}
int ind = -1;
class TimeSlotSection extends StatefulWidget {
  final String label;
  final List<String> slots;
  final IconData icon;

  const TimeSlotSection({
    Key? key,
    required this.label,
    required this.slots,
    required this.icon,
  }) : super(key: key);

  @override
  State<TimeSlotSection> createState() => _TimeSlotSectionState();
}

class _TimeSlotSectionState extends State<TimeSlotSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 20),
            SizedBox(width: 10),
            Text('${widget.label} ${widget.slots.length} slots', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(widget.slots.length, (index) {
            return GestureDetector(
              onTap: (){
                setState(() {
                  ind = index;
                });
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AppointmentScreen(),
                      ctx: context),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: ind == index ? Border.all( color: Colors.green) : Border.all( color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(Helpers.formatTime(widget.slots[index]), style: TextStyle(color:  ind == index ?  Colors.green :Colors.blueAccent)),
              ),
            );
          }),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
