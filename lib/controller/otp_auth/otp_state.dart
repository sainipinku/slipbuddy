part of 'otp_cubit.dart';

sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpSuccess extends OtpState {}

final class OtpResendSuccess extends OtpState {}

final class OtpFailed extends OtpState {}

final class OtpInternetError extends OtpState {}

final class OtpTimeout extends OtpState {}

final class OtpOnHold extends OtpState {}

class RoleSelected extends OtpState {
  final String selectedRole;

  RoleSelected({required this.selectedRole});

  @override
  List<Object> get props => [selectedRole];
}
