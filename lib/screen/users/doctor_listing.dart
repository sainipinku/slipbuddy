import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/doctor/doctor_cubit.dart';
import 'package:slipbuddy/screen/users/ClinicVisitScreen.dart';

class DoctorListing extends StatefulWidget {
  final String id;
  const DoctorListing({super.key,required this.id});

  @override
  State<DoctorListing> createState() => _DoctorListingState();
}

class _DoctorListingState extends State<DoctorListing> {
  late DoctorCubit doctorCubit;
  initCubit() {
    var body = {"categoryid" : widget.id};
    doctorCubit = context.read<DoctorCubit>();
    doctorCubit.fetchDoctor(body);
    print("----------------------------------------------------");
  }

  @override
  void initState() {
    initCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonAppBar(
        title: 'Doctor Listing',
        backgroundColor: AppTheme.statusBar,
        actions: [
         // Icon(Icons.search),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DoctorCubit, DoctorState>(
            listener: (context, state) {
              if (state is DoctorLoading) {
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
              } else if (state is DoctorLoaded) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Status update successfully', Icons.done, Colors.green);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);

              } else if (state is DoctorFailed) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is DoctorTimeout) {
                // Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is DoctorInternetError) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is DoctorLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            },
          ),
        ],
        child: BlocBuilder<DoctorCubit, DoctorState>(
          builder: (context, state) {
            if (state is DoctorLoaded) {
              // Set the max item count to 6 or less, plus 1 if there are more than 6 items for the 'More' button
              int itemCount = state.DoctorList.length;

              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: itemCount, // Dynamic count based on list length
                itemBuilder: (context, index) {
                  //final doctor = doctors[index];
                  final doctor = state.DoctorList[index];
                  return Column(
                    children: [
                      DoctorCard(
                        doctorId: doctor.id!,
                        doctorName: doctor.fullName!,
                        experience: doctor.experience!,
                        rating: double.parse(doctor.Ranking!),
                        hospital: doctor.hospitalName!,
                        location: doctor.location!,
                        fee: doctor.fees!.toString(),
                        availableAt: doctor.NextAvailable!,
                        imagePath: doctor.profilePic!, // Dynamic image path
                          HospitalID : doctor.HospitalID!,
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('No Announcement Found'));
            }
          },
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Orthopedist',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final int doctorId;
  final String doctorName;
  final String experience;
  final double rating;
  final String hospital;
  final String location;
  final String fee;
  final String availableAt;
  final String imagePath;
  final int HospitalID;

  DoctorCard({
    required this.doctorId,
    required this.doctorName,
    required this.experience,
    required this.rating,
    required this.hospital,
    required this.location,
    required this.fee,
    required this.availableAt,
    required this.imagePath,
    required this.HospitalID,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Center(
                      child:
                      FadeInImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.cover,
                        placeholder:
                        const AssetImage(
                            "assets/images/google.png"),
                        imageErrorBuilder:
                            (context,
                            error,
                            stackTrace) {
                          return Image
                              .asset(
                            "assets/images/google.png",
                          );
                        },
                      )),// Use NetworkImage for a URL image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(experience),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        Text(rating.toString(), style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(hospital),
            Text('Location: $location'),
            SizedBox(height: 10),
            Text('₹ $fee Consultation Fees'),
            SizedBox(height: 5),
            Text('Next Available At: $availableAt'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.statusBar
                  ),
                  child: Text('Contact Hospital',style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ClinicVisitScreen(doctorId: doctorId,HospitalID: HospitalID,profile: imagePath,name: doctorName,location: location,),
                          ctx: context),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusBar
                  ),
                  child: Text('Book Clinic Visit',style:  GoogleFonts.roboto(
                    color: AppTheme.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class Doctor {
  final String doctorName;
  final String experience;
  final double rating;
  final String hospital;
  final String location;
  final int fee;
  final String availableAt;
  final String imagePath;

  Doctor({
    required this.doctorName,
    required this.experience,
    required this.rating,
    required this.hospital,
    required this.location,
    required this.fee,
    required this.availableAt,
    required this.imagePath,
  });
}