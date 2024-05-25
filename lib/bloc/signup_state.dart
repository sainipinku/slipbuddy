import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  const SignUpState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory SignUpState.initial() {
    return const SignUpState(
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SignUpState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return SignUpState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  List<Object> get props => [firstName, lastName, email, password, isSubmitting, isSuccess, isFailure];
}
