import 'package:flutter/material.dart';

import '../constants/app_theme.dart';
class ConsulataionScreen extends StatelessWidget{
  const ConsulataionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        title: const Text('Consulataion'),
        centerTitle: true, // Optional: to center the title
      ),

    );
  }
}