import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String message;

  const PaymentFailedScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: Text(
          "Payment Failed",
          style: GoogleFonts.poppins(
            color: AppTheme.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // You can use any icon here
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              "Payment Failed!",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(message,style: GoogleFonts.poppins(
              color: AppTheme.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.statusBar,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                "Try Again",
                style: GoogleFonts.roboto(
                  color: AppTheme.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
