import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgetPasswordEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SubmitEmail extends ForgetPasswordEvent {}
