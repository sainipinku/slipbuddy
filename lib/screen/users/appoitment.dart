import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/constants/common_ui.dart';

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: Text(
          "Book In-Clinic Appointment",
          style: GoogleFonts.roboto(
            color: AppTheme.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // You can use any icon here
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. Punit Chitlangia",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Oral And Maxillofacial Surgeon",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.green, size: 16),
                          Text(" 100%"),
                          SizedBox(width: 10),
                          Icon(Icons.comment, color: Colors.green, size: 16),
                          Text(" 18 Patient Stories"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),

            // Appointment Time Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Appointment time"),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 5),
                          Text("Mon, 14 Oct 10:45 AM"),
                        ],
                      ),
                    ],
                  ),
                  Text("in 14 hours and 42 minutes"),
                ],
              ),
            ),

            Divider(),

            // Clinic Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Clinic Details"),
                  SizedBox(height: 5),
                  Text(
                    "Shekhawati Dental, Face & Hair Clinic\nG15, Dhansshree Tower II, Central Spine, Vidyadhar Nagar",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.purple),
                      SizedBox(width: 5),
                      Text("Practo Promise - Appointment confirmed instantly"),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),

            // Apply Coupon Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Apply Coupon"),
                  GestureDetector(
                    onTap: () {
                      // Handle apply coupon
                    },
                    child: Text(
                      "APPLY",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            Divider(),

            // Bill Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("In-Clinic Appointment for"),
                      GestureDetector(
                        onTap: () {
                          // Handle change patient
                        },
                        child: Text(
                          "CHANGE",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Ram Saini",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹300"),
                      TextButton(
                        onPressed: () {
                          // Handle view bill
                        },
                        child: Text("View Bill"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Confirm Clinic Visit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: commonButton(color: AppTheme.statusBar, text: 'Confirm Clinic Visit', button: () {

              },borderRadius: 5.0),
            ),

          ],
        ),
      ),
    );
  }
}
