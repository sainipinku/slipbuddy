part of 'appointmentstatus_cubit.dart';

@immutable
sealed class AppointmentStatusState {}

final class AppointmentStatusInitial extends AppointmentStatusState {}

final class AppointmentStatusLoading extends AppointmentStatusState {}

final class AppointmentStatusLoaded extends AppointmentStatusState {
  final AppointStatusUpdateModel appointmentList;

  AppointmentStatusLoaded({required this.appointmentList});
}

final class AppointmentStatusFailed extends AppointmentStatusState {}

final class AppointmentStatusInternetError extends AppointmentStatusState {}

final class AppointmentStatusTimeout extends AppointmentStatusState {}

final class AppointmentStatusLogout extends AppointmentStatusState {}
