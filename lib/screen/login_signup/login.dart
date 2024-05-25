import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/screen/login_signup/signup.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_event.dart';
import '../../bloc/login_state.dart';
import '../../bloc/state.dart';
import 'forget_password.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/splash.png',
            height: 100, // Adjust the height as needed
          ),
          SizedBox(height: 80.0),
          _EmailInput(),
          SizedBox(height: 8.0),
          _PasswordInput(),
          SizedBox(height: 8.0),
          _LoginButton(),
          SizedBox(height: 8.0),
          _LoginStateDisplay(),
          SizedBox(height: 2.0),
          _RoleSelection(),
         // SizedBox(height: 8.0),
          //_ForgotPasswordButton(),
         // SizedBox(height: 8.0),
          //_SignUpButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<LoginBloc>().add(LoginEmailChanged(value)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.isFailure ? 'Invalid email or password' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.isFailure ? 'Invalid email or password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.isSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () {
            // Handle login logic
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            // Button text color
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            // Button size
            textStyle: TextStyle(fontSize: 18),
            // Button text size
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
          ),
          child: Text('Login'),
        );
      },
    );
  }
}
class _RoleSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: Text('Patient'),
                value: 'Patient',
                groupValue: state.selectedRole,
                onChanged: (value) {
                  context.read<RoleBloc>().add(RoleSelected(value!));
                },
              ),
              RadioListTile(
                title: Text('Doctor'),
                value: 'Doctor',
                groupValue: state.selectedRole,
                onChanged: (value) {
                  context.read<RoleBloc>().add(RoleSelected(value!));
                },
              ),
              RadioListTile(
                title: Text('Agent'),
                value: 'Agent',
                groupValue: state.selectedRole,
                onChanged: (value) {
                  context.read<RoleBloc>().add(RoleSelected(value!));
                },
              ),
            ]
        );
      },
    );
  }
}

class _LoginStateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.isSuccess) {
          return Text('Login Successful!', style: TextStyle(color: Colors.green));
        } else if (state.isFailure) {
          return Text('Login Failed!', style: TextStyle(color: Colors.red));
        } else if (state.isForgotPassword) {
          return Text('Password reset link sent!', style: TextStyle(color: Colors.blue));
        } else if (state.isSignUp) {
          return Text('Sign Up Successful!', style: TextStyle(color: Colors.green));
        }
        return Container();
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
        );
      },
      child: Text('Forgot Password?'),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: Text('Sign Up'),
    );
  }
}