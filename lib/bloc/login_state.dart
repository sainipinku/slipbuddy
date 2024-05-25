import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isForgotPassword;
  final bool isSignUp;

  const LoginState({
    required this.email,
    required this.password,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.isForgotPassword = false,
    this.isSignUp = false,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isForgotPassword,
    bool? isSignUp,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isForgotPassword: isForgotPassword ?? this.isForgotPassword,
      isSignUp: isSignUp ?? this.isSignUp,
    );
  }

  @override
  List<Object> get props => [email, password, isSubmitting, isSuccess, isFailure, isForgotPassword, isSignUp];
}
