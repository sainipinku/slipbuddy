import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;

  const ForgetPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

class EmailValid extends ForgetPasswordState {}

class EmailInvalid extends ForgetPasswordState {}
