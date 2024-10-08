part of 'slots_cubit.dart';

@immutable
sealed class SlotsState {}


final class SlotsInitial extends SlotsState {}

final class SlotsLoading extends SlotsState {}

final class SlotsLoaded extends SlotsState {
  final List<SlotsModel> SlotsList;

  SlotsLoaded({required this.SlotsList});
}

final class SlotsFailed extends SlotsState {}

final class SlotsInternetError extends SlotsState {}

final class SlotsTimeout extends SlotsState {}

final class SlotsLogout extends SlotsState {}