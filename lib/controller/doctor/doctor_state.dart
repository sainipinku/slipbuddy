part of 'doctor_cubit.dart';

@immutable
sealed class DoctorState {}


final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorLoaded extends DoctorState {
  final List<DoctorModel> DoctorList;

  DoctorLoaded({required this.DoctorList});
}

final class DoctorFailed extends DoctorState {}

final class DoctorInternetError extends DoctorState {}

final class DoctorTimeout extends DoctorState {}

final class DoctorLogout extends DoctorState {}