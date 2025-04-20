part of 'global_search_cubit.dart';

@immutable
sealed class GlobalSearchState {}

final class GlobalSearchInitial extends GlobalSearchState {}

final class GlobalSearchLoading extends GlobalSearchState {}

final class GlobalSearchLoaded extends GlobalSearchState {
  final List<DoctorModel> DoctorList;

  GlobalSearchLoaded({required this.DoctorList});
}

final class GlobalSearchFailed extends GlobalSearchState {}

final class GlobalSearchInternetError extends GlobalSearchState {}

final class GlobalSearchTimeout extends GlobalSearchState {}

final class GlobalSearchLogout extends GlobalSearchState {}
