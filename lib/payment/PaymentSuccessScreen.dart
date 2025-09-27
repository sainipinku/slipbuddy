import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String paymentId;

  const PaymentSuccessScreen({super.key, required this.paymentId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: Text(
          "Payment Successful",
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
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Payment ID: ${widget.paymentId}",style: GoogleFonts.poppins(
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
                "Back to Home",
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
