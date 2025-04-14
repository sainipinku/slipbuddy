import 'package:flutter/material.dart';

import '../constants/app_theme.dart';
class TestBookingScreen extends StatelessWidget {
  const TestBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: const Text('Test Booking'),
        centerTitle: true, // Optional: to center the title
      ),

    );
  }
}