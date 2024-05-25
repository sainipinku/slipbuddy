import 'package:flutter/material.dart';

import '../Model/patient.dart';

class PatientList extends StatelessWidget {
  final List<Patient> patients;

  PatientList({required this.patients});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return ListTile(
          title: Text(patient.name),
          subtitle: Text(patient.condition),
          trailing: patient.needsAttention ? Icon(Icons.warning, color: Colors.red) : null,
        );
      },
    );
  }
}
