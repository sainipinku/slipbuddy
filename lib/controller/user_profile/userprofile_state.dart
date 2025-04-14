
part of 'userprofile_cubit.dart';

@immutable
sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final List<UserProfileModel> userList;

  UserProfileLoaded({required this.userList});
}

class MultipleDataLoaded extends UserProfileState {
  final List<UserProfileModel> userList;

  MultipleDataLoaded({required this.userList});
}
final class UserProfileFailed extends UserProfileState {}

final class UserProfileInternetError extends UserProfileState {}

final class UserProfileTimeout extends UserProfileState {}

final class UserProfileLogout extends UserProfileState {}
