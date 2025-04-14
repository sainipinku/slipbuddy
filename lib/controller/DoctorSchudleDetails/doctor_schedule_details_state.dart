part of 'doctor_Schedule_Details_cubit.dart';

sealed class DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsInitial extends DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsLoading extends DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsLoaded extends DoctorScheduleDetailsState {
  final List<DoctorScheduleDetailsModel> DoctorScheduleDetailsList;

  DoctorScheduleDetailsLoaded({required this.DoctorScheduleDetailsList});
}

final class DoctorScheduleDetailsFailed extends DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsInternetError extends DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsTimeout extends DoctorScheduleDetailsState {}

final class DoctorScheduleDetailsLogout extends DoctorScheduleDetailsState {}

