import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.initial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpFirstNameChanged) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is SignUpLastNameChanged) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is SignUpEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(isSubmitting: true);

      // Simulating a sign-up process
      await Future.delayed(Duration(seconds: 2));

      // Example logic for sign-up success/failure
      if (state.firstName.isNotEmpty && state.lastName.isNotEmpty && state.email.isNotEmpty && state.password.isNotEmpty) {
        yield state.copyWith(isSubmitting: false, isSuccess: true);
      } else {
        yield state.copyWith(isSubmitting: false, isFailure: true);
      }
    }
  }
}
