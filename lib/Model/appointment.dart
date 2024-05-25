import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final DateTime dateTime;
  final String status; // upcoming, completed, canceled

  Appointment({
    required this.id,
    required this.patientName,
    required this.dateTime,
    required this.status,
  });

  @override
  List<Object?> get props => [id, patientName, dateTime, status];
}
