import 'package:flutter/material.dart';

import '../constants/app_theme.dart';

class OrderScreen extends StatelessWidget{
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: const Text('Order'),
        centerTitle: true, // Optional: to center the title
      ),

    );
  }
}