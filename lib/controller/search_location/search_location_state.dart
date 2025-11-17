part of 'search_location_cubit.dart';

@immutable
sealed class SearchLocationState {}

final class SearchLocationInitial extends SearchLocationState {}

final class SearchLocationLoading extends SearchLocationState {}

/// 🔹 Recent Search API Response
final class SearchSearchLocationLoaded extends SearchLocationState {
  final List<GetRecentSearchModel> recentSearchList;
  SearchSearchLocationLoaded({required this.recentSearchList});
}

final class SearchLocationFailed extends SearchLocationState {}

final class SearchLocationInternetError extends SearchLocationState {}

final class SearchLocationTimeout extends SearchLocationState {}

final class SearchLocationLogout extends SearchLocationState {}
final class AddRecentSearchLocationSuccess extends SearchLocationState {}
