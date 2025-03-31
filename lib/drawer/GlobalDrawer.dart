// global_drawer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/bottom_diloag/logout.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/screen/users/appoitment_history/appoitment_history.dart';
import 'package:slipbuddy/screen/welcome/welcome.dart';

class GlobalDrawer extends StatelessWidget {
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
                          'Ramchandra',
                          style: GoogleFonts.poppins(
                            color: AppTheme.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          'My App',
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
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
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
