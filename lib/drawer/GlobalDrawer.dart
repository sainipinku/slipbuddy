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
  String imageUrl = "";
  // Function to get data from SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_first_name') ?? ''; // Default to an empty string if null
      email = prefs.getString('user_email') ?? '';
      imageUrl = prefs.getString('user_profile') ?? '';
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
                  Navigator.of(context).pop();
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
                      radius: 22,

                      // Adjusted to fit inside the container
                      backgroundImage: (imageUrl.isNotEmpty)
                          ? NetworkImage(imageUrl)
                          : AssetImage('assets/images/defult_img.png') as ImageProvider,
                      backgroundColor: Colors.white,
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
            leading: Icon(Icons.home),
            title: Text('Reminder',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {

            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Payment',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {

            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Setting',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.blackColor)),
            onTap: () {

            },
            trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
          ),*/
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
