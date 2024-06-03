part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginResendSuccess extends LoginState {}

final class LoginFailed extends LoginState {}

final class LoginInternetError extends LoginState {}

final class LoginTimeout extends LoginState {}

final class LoginOnHold extends LoginState {}

class RoleSelected extends LoginState {
  final String selectedRole;

  RoleSelected({required this.selectedRole});

  @override
  List<Object> get props => [selectedRole];
}
