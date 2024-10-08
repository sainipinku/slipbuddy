part of 'date_cubit.dart';

@immutable
sealed class DateState {}

final class DateInitial extends DateState {}

final class DateLoading extends DateState {}

final class DateSlotsLoaded extends DateState {
  final List<SlotsDateModel> dateSlotsList;

  DateSlotsLoaded({required this.dateSlotsList});
}

final class DateFailed extends DateState {}

final class DateInternetError extends DateState {}

final class DateTimeout extends DateState {}

final class DateLogout extends DateState {}