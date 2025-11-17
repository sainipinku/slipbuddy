import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final int HospitalID;
  final String profile;
  final String name;
  final String location;
  const ClinicVisitScreen({super.key,required this.doctorId,required this.HospitalID,required this.profile,required this.name,required this.location});
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
  //  date = Helpers.dateformat(currentDate);
    print("----------------------------------------------------");
  }
 String date = '12/15/2024 12:00:00 AM';
  // Helper function to get month name
  @override
  void initState() {
    DateTime now = DateTime.now();
    date = DateFormat('MM/dd/yyyy hh:mm:ss a').format(now); // Formats as "15 Dec"
    print("Current Date: $date"); // Output: "Current Date: 15 Dec"
    initCubit();
    super.initState();
  }
  int selectedIndex = 1; // Default selected date index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20, // Size of the circle
              child: ClipOval( // Ensures the image is clipped to a circle
                child: FadeInImage(
                  image: NetworkImage(widget.profile), // Network image from a URL
                  fit: BoxFit.cover, // Ensures the image covers the circle
                  placeholder: const AssetImage("assets/images/defult_img.png"), // Placeholder image
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/defult_img.png", // Fallback image if URL fails
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600)),
                  Text(widget.location,maxLines: 1, style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600)),
                ],
              ),
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
                } else if (state is DateSlotsLoaded) {
                  // Navigator.of(context).pop();


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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clinic Visit Slots', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
                SizedBox(height: 10),
                BlocBuilder<DateCubit, DateState>(builder: (context,state){
                  if(state is DateSlotsLoaded) {
                    int itemCount = state.dateSlotsList.length;
                    var slots = state.dateSlotsList;
                    return Container(
                      height: 58, // Adjust height based on your need
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                date = slots[index].date!;
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
                                border: Border.all(color: AppTheme.statusBar),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(Helpers.dateformat(slots[index].date!), style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400)),
                                  Text(slots[index].status!, style: GoogleFonts.poppins(fontSize: 12, color: slots[index].status! == 'Available' ? Colors.green : AppTheme.statusBar)),
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
                SizedBox(height: 10),
                Text(Helpers.dateformat(date), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
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
                          date: date,
                          doctorId: widget.doctorId,
                          HospitalID: widget.HospitalID,
                          profile: widget.profile,
                          name: widget.name,
                          location: widget.location,
                        ),
                        TimeSlotSection(
                          label: 'Afternoon',
                          slots: noonSlots,
                          icon: Icons.wb_cloudy,
                          date: date,
                          doctorId: widget.doctorId,
                          HospitalID: widget.HospitalID,
                          profile: widget.profile,
                          name: widget.name,
                          location: widget.location,
                        ),
                        TimeSlotSection(
                          label: 'Evening',
                          slots: eveningSlots,
                          icon: Icons.nights_stay,
                          date: date,
                          doctorId: widget.doctorId,
                          HospitalID: widget.HospitalID,
                          profile: widget.profile,
                          name: widget.name,
                          location: widget.location,
                        ),
                      ],
                    );
                  }else {
                    return const Center(child: Text('No Announcement Found'));
                  }
                }),
                // Bottom ad and button

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
                        backgroundColor: AppTheme.statusBar,
                        textStyle:  GoogleFonts.poppins(
                          color: AppTheme.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        ,
      ),
    );
  }
}
String selectTime = '';
class TimeSlotSection extends StatefulWidget {
  final String label;
  final String date;
  final List<String> slots;
  final IconData icon;
  final int doctorId;
  final int HospitalID;
  final String profile;
  final String name;
  final String location;
  const TimeSlotSection({
    Key? key,
    required this.date,
    required this.label,
    required this.slots,
    required this.icon,
    required this.doctorId,
    required this.HospitalID,
    required this.profile,
    required this.name,
    required this.location,
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
            Text('${widget.label} ${widget.slots.length} slots', style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black)),
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
                  selectTime = widget.slots[index];
                });
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AppointmentScreen(date: widget.date, time: widget.slots[index],doctorId: widget.doctorId,HospitalID: widget.HospitalID,profile: widget.profile,name: widget.name,location: widget.location,),
                      ctx: context),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: selectTime == widget.slots[index] ? Border.all( color: Colors.green) : Border.all( color: AppTheme.statusBar),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(Helpers.formatTime(widget.slots[index]), style: GoogleFonts.poppins(color:  selectTime == widget.slots[index] ?  Colors.green :AppTheme.statusBar,fontSize: 14,fontWeight: FontWeight.w400)),
              ),
            );
          }),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
