part of 'promise_cubit.dart';

sealed class PromiseState {}

final class PromiseInitial extends PromiseState {}

final class PromiseLoading extends PromiseState {}

final class PromiseSuccess extends PromiseState {

  List<AppointmentPromiseModel> appointmentPromiseList;

  PromiseSuccess({required this.appointmentPromiseList});
}

final class PromiseResendSuccess extends PromiseState {}

final class PromiseFailed extends PromiseState {}

final class PromiseInternetError extends PromiseState {}

final class PromiseTimeout extends PromiseState {}

final class PromiseOnHold extends PromiseState {}

