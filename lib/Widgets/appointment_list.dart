import 'package:flutter/material.dart';

import '../Model/appointment.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          title: Text(appointment.patientName),
          subtitle: Text('${appointment.dateTime}'),
          trailing: Text(appointment.status),
        );
      },
    );
  }
}
