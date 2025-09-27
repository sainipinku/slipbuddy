// full working code with feedback and contact us toggle

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/bottom_diloag/logout.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/profile/edit_profile_page.dart';
import 'package:slipbuddy/screen/DeleteAccountScreen/DeleteAccountScreen.dart';
import 'package:slipbuddy/screen/users/appoitment_history/appoitment_history.dart';
import 'package:slipbuddy/screen/users/payment_screen.dart';
import 'package:slipbuddy/webviewpage.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalDrawer extends StatefulWidget {
  @override
  State<GlobalDrawer> createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {
  String name = '';
  String email = '';
  String imageUrl = '';
  bool showFeedback = false;
  bool showContact = false;
  bool showSettings = false;

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_first_name') ?? '';
      email = prefs.getString('user_email') ?? '';
      imageUrl = prefs.getString('user_profile') ?? '';
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
  void sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Needed&body=Hello, I need help with...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not send email to $email';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.statusBar),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: EditProfilePage(),
                      ctx: context,
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: (imageUrl.isNotEmpty)
                          ? NetworkImage(imageUrl)
                          : AssetImage('assets/images/defult_img.png')
                      as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                                color: AppTheme.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                                color: AppTheme.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/appoitment.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'Appointment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.blackColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppoitmentHistory()),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                ),

                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/payment.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Payment',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.blackColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen()),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                ),
                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/feedback.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Feedback',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.blackColor)),
                  onTap: () {
                    setState(() {
                      showFeedback = !showFeedback;
                      showContact = false;
                    });
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/contactus.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Contact Us',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          showContact ? FontWeight.bold : FontWeight.w500,
                          color: AppTheme.blackColor)),
                  trailing: Icon(
                      showContact ? Icons.expand_less : Icons.expand_more,
                      size: 18),
                  onTap: () {
                    setState(() {
                      showContact = !showContact;
                      showFeedback = false;
                    });
                  },
                ),
                if (showContact)
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            makePhoneCall('+91-7412013030');
                          },
                          child: Row(children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 5),
                            Text('+91-7412013030',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ]),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: (){
                            sendEmail('slipbuddy2022@gmail.com');
                          },
                          child: Row(children: [
                            Icon(Icons.email, size: 18),
                            SizedBox(width: 5),
                            Text('Support@slipbuddy.com',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/setting.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Settings',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          showSettings ? FontWeight.bold : FontWeight.w500,
                          color: AppTheme.blackColor)),
                  trailing: Icon(
                      showSettings ? Icons.expand_less : Icons.expand_more,
                      size: 18),
                  onTap: () {
                    setState(() {
                      showSettings = !showSettings;
                      showContact = false;
                      showFeedback = false;
                    });
                  },
                ),
                if (showSettings)
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.share, size: 18),
                          title: Text("Share", style: GoogleFonts.poppins(fontSize: 14)),
                          onTap: () {
                            Share.share(
                              'Check out this amazing app: https://play.google.com/store/apps/details?id=com.gs.slipbuddy',
                              subject: 'Try this app!',
                            );
                          }, // Add your action
                        ),
                        ListTile(
                          leading: Icon(Icons.article, size: 18),
                          title: Text("Terms of Use", style: GoogleFonts.poppins(fontSize: 14)),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: WebViewPage(url: 'https://slipbuddy.com/terms',),
                                  ctx: context),
                            );
                          }, // Add your action
                        ),
                        ListTile(
                          leading: Icon(Icons.privacy_tip, size: 18),
                          title: Text("Privacy Policy", style: GoogleFonts.poppins(fontSize: 14)),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: WebViewPage(url: 'https://slipbuddy.com/policy',),
                                  ctx: context),
                            );
                          }, // Add your action
                        ),
                        ListTile(
                          leading: Icon(Icons.info_outline, size: 18),
                          title: Text("About Us", style: GoogleFonts.poppins(fontSize: 14)),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: WebViewPage(url: 'https://slipbuddy.com/home#about-section',),
                                  ctx: context),
                            );
                          }, // Add your action
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_forever, size: 18),
                          title: Text("Delete Account", style: GoogleFonts.poppins(fontSize: 14)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteAccountScreen()),
                            );
                          }, // Add your action
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  leading: Container(
                    width: 40, // Adjust size as needed
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/logout.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.blackColor)),
                  onTap: () {
                    Navigator.pop(context);
                    LogoutBottomDilog(context);
                  },
                ),
              ],
            ),
          ),
          if (showFeedback) _buildFeedbackSection(),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      width: double.infinity,
      color: AppTheme.statusBar,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => setState(() => showFeedback = false),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Icon(Icons.emoji_emotions, size: 40, color: Colors.yellow),
          SizedBox(height: 10),
          Text(
            "Tell Us What You Think",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
                  (index) => Icon(Icons.star, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
