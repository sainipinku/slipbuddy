part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

/// 🔹 Location API Response
final class LocationLoaded extends LocationState {
  final List<GetLocationModel> locationList;
  LocationLoaded({required this.locationList});
}

final class LocationFailed extends LocationState {}

final class LocationInternetError extends LocationState {}

final class LocationTimeout extends LocationState {}

final class LocationLogout extends LocationState {}
final class AddSuccess extends LocationState {}
