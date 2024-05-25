

import 'package:equatable/equatable.dart';
import 'package:slipbuddy/Model/appointment.dart';

class DoctorDashboardState extends Equatable {
  const DoctorDashboardState();

  @override
  List<Object> get props => [];
}
class DoctorDashboardLoading extends DoctorDashboardState {}

class DoctorDashboardLoaded extends DoctorDashboardState {
  final List<Appointment> upcomingAppointments;

  const DoctorDashboardLoaded({required this.upcomingAppointments});

  @override
  List<Object> get props => [upcomingAppointments];
}

class DoctorDashboardError extends DoctorDashboardState {}

