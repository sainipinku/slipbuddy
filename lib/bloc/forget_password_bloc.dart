import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial());

  @override
  Stream<ForgetPasswordState> mapEventToState(ForgetPasswordEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is SubmitEmail) {
      yield* _mapSubmitEmailToState();
    }
  }

  Stream<ForgetPasswordState> _mapEmailChangedToState(String email) async* {
    if (EmailValidator.validate(email)) {
      yield EmailValid();
    } else {
      yield EmailInvalid();
    }
  }

  Stream<ForgetPasswordState> _mapSubmitEmailToState() async* {
    yield ForgetPasswordLoading();
    try {
      // Simulate a call to a repository or API
      await Future.delayed(Duration(seconds: 2));
      yield ForgetPasswordSuccess();
    } catch (error) {
      yield ForgetPasswordFailure(error.toString());
    }
  }
}
