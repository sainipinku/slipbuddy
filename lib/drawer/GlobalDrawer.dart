// global_drawer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/bottom_diloag/logout.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/drawer_list/consultsation_page.dart';
import 'package:slipbuddy/drawer_list/orders_page.dart';
import 'package:slipbuddy/profile/edit_profile_page.dart';
import 'package:slipbuddy/screen/users/appoitment_history/appoitment_history.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';

import '../drawer_list/test_booking.dart';

class GlobalDrawer extends StatefulWidget {
  @override
  State<GlobalDrawer> createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {
  String name = '';
  String email = '';

  // Function to get data from SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? ''; // Default to an empty string if null
      email = prefs.getString('user_email') ?? '';
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.statusBar,
              ),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: EditProfilePage(),
                        ctx: context),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25, // Adjust the radius as needed
                      backgroundImage: NetworkImage('https://via.placeholder.com/25x25.png?text=Banner+2'), // Replace with your image URL
                      // Alternatively, use AssetImage for local images
                      // backgroundImage: AssetImage('assets/images/profile.png'),
                      child: Text(
                        'AB', // Initials can be shown in case the image fails to load
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              color: AppTheme.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                                color: AppTheme.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "PLUS",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text("Health Plan for your family"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // Add logic
            },
          ),
          Divider( thickness: 10,),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Appointment',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppoitmentHistory()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
        /*  ListTile(
            leading: Icon(Icons.copy),
            title: Text('Test Bookings',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestBookingScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),*/
       /*   ListTile(
            leading: Icon(Icons.hourglass_bottom_outlined),
            title: Text('Orders',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.note_alt),
            title: Text('Consultations',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),*/
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('My doctors',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.horizontal_split),
            title: Text('Medical records',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.plus_one),
            title: Text('My Insurance Policy',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.watch_later_rounded),
            title: Text('Reminders',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment & HealthCash',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsulataionScreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          Divider( thickness: 10,),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Read about health' ,style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {
              Navigator.pushNamed(context, '/Read About Health');
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help Center' ,style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.blackColor)),
            onTap: () {
              Navigator.pushNamed(context, '/Help Center');
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings' ,style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.blackColor)),
            onTap: () {
              Navigator.pushNamed(context, '/Settings');
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.thumb_up),
            title: Text('Like us? Give us 5 star' , style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.blackColor)),
            onTap: () {
              Navigator.pushNamed(context, '/Like us');
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.medical_services_outlined),
            title: Text('Are you doctor?' ,style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.blackColor)),
            onTap: () {
              Navigator.pushNamed(context, '/are you doctor');
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout' ,style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.blackColor)),
            onTap: () {

              // Add your logout logic here
              Navigator.pop(context);
              LogoutBottomDilog(context);

            },
          ),
        ],
      ),
    );
  }
}
