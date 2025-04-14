
part of 'updateuserprofile_cubit.dart';

@immutable
sealed class UpdateUserProfileState {}

final class UpdateUserProfileInitial extends UpdateUserProfileState {}

final class UpdateUserProfileLoading extends UpdateUserProfileState {}

class UpdateUserProfile extends UpdateUserProfileState {
  final UpdateUserProfileModel updateUserProfileModel;

  UpdateUserProfile({required this.updateUserProfileModel});
}
final class UpdateUserProfileFailed extends UpdateUserProfileState {}

final class UpdateUserProfileInternetError extends UpdateUserProfileState {}

final class UpdateUserProfileTimeout extends UpdateUserProfileState {}

final class UpdateUserProfileLogout extends UpdateUserProfileState {}
