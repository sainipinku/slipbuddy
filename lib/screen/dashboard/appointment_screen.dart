import 'package:flutter/material.dart';


class AppointmentScreen extends StatefulWidget {
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Appointments',style: TextStyle(color: Colors.black,fontSize: 35),)),
    );
  }
}

