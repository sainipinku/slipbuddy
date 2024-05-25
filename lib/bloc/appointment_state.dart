part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  const AppointmentLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class AppointmentError extends AppointmentState {}
