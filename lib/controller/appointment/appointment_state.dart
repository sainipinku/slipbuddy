part of 'appointment_cubit.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointmentList;

  AppointmentLoaded({required this.appointmentList});
}

final class AppointmentFailed extends AppointmentState {}

final class AppointmentInternetError extends AppointmentState {}

final class AppointmentTimeout extends AppointmentState {}

final class AppointmentLogout extends AppointmentState {}
