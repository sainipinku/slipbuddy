import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/constants/app_theme.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.calendar_today,
      "title": "Appointment Confirmation",
      "message": "Your appointment with Dr. Mehta is confirmed for 3:00 PM, May 20 at CityCare Hospital.",
      "date": "20 May",
      "iconColor": Colors.red,
    },
    {
      "icon": Icons.payment,
      "title": "Payment Successful",
      "message": "Payment of ₹500 for your appointment with Dr. Gupta has been successfully processed.",
      "date": "20 May",
      "iconColor": Colors.amber[800],
    },
    {
      "icon": Icons.notifications_active,
      "title": "Upcoming Appointment Reminder",
      "message": "You’ve received a new message from Smile Dental Clinic. Tap to view",
      "date": "20 May",
      "iconColor": Colors.redAccent,
    },
    {
      "icon": Icons.feedback,
      "title": "Feedback Request",
      "message": "We hope your visit went well! Please share your feedback to help us improve.",
      "date": "20 May",
      "iconColor": Colors.blueAccent,
    },
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Notification',
        backgroundColor: AppTheme.statusBar,
        actions: [
          // Icon(Icons.search),
        ],
      ),
      body: notifications.isNotEmpty ? ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var item = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(item['icon'], color: item['iconColor'], size: 20),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        item['date'],
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['message'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
    :
      Center(
        child: Text('No Record Found',style: TextStyle(color: Colors.black,fontSize: 16),),
      ),
    );
  }
}
