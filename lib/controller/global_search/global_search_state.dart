part of 'global_search_cubit.dart';

sealed class GlobalSearchState {}

final class GlobalSearchInitial extends GlobalSearchState {}

final class GlobalSearchLoading extends GlobalSearchState {}

final class GlobalSearchSuccess extends GlobalSearchState {}

final class GlobalSearchResendSuccess extends GlobalSearchState {}


final class GlobalSearchLoaded extends GlobalSearchState {
  final List<DoctorModel> doctorList;

  GlobalSearchLoaded({required this.doctorList});
}

final class GlobalSearchFailed extends GlobalSearchState {}

final class GlobalSearchInternetError extends GlobalSearchState {}

final class GlobalSearchTimeout extends GlobalSearchState {}

final class GlobalSearchLogout extends GlobalSearchState {}

final class GlobalSearchOnHold extends GlobalSearchState {}


