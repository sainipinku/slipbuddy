part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class LoadAppointments extends AppointmentEvent {
  final String status; // upcoming, completed, canceled

  const LoadAppointments({required this.status});

  @override
  List<Object> get props => [status];
}
