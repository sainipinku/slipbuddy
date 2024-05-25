import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(isSubmitting: true);

      // Simulating a login process
      await Future.delayed(Duration(seconds: 2));

      // Example logic for login success/failure
      if (state.email == 'test@example.com' && state.password == 'password') {
        yield state.copyWith(isSubmitting: false, isSuccess: true);
      } else {
        yield state.copyWith(isSubmitting: false, isFailure: true);
      }
    } else if (event is ForgotPasswordSubmitted) {
      // Simulating forgot password process
      yield state.copyWith(isForgotPassword: true);
      await Future.delayed(Duration(seconds: 2));
      yield state.copyWith(isForgotPassword: false);
    } else if (event is SignUpSubmitted) {
      // Simulating sign-up process
      yield state.copyWith(isSignUp: true);
      await Future.delayed(Duration(seconds: 2));
      yield state.copyWith(isSignUp: false);
    }
  }
}
