part of 'schudle_cubit.dart';

sealed class SchudleState {}

final class SchudleInitial extends SchudleState {}

final class SchudleLoading extends SchudleState {}

final class SchudleSuccess extends SchudleState {

  final AppointmentRegisterModel appointment;

  SchudleSuccess({required this.appointment});
}
final class PaymentSuccess extends SchudleState {

  final AppointmentRegisterModel appointment;

  PaymentSuccess({required this.appointment});
}
final class PaymentFail extends SchudleState {

  final AppointmentRegisterModel appointment;

  PaymentFail({required this.appointment});
}

final class SchudleResendSuccess extends SchudleState {}

final class SchudleFailed extends SchudleState {}

final class SchudleInternetError extends SchudleState {}

final class SchudleTimeout extends SchudleState {}

final class SchudleOnHold extends SchudleState {}

