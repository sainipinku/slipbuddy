import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpFirstNameChanged extends SignUpEvent {
  final String firstName;

  const SignUpFirstNameChanged(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class SignUpLastNameChanged extends SignUpEvent {
  final String lastName;

  const SignUpLastNameChanged(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  const SignUpPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
