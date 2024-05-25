import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/signup_bloc.dart';
import '../../bloc/signup_event.dart';
import '../../bloc/signup_state.dart';
import 'login.dart';


class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
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
          _FirstNameInput(),
          SizedBox(height: 8.0),
          _LastNameInput(),
          SizedBox(height: 8.0),
          _EmailInput(),
          SizedBox(height: 8.0),
          _PasswordInput(),
          SizedBox(height: 8.0),
          _SignUpButton(),
          SizedBox(height: 8.0),
          _SignUpStateDisplay(),
          SizedBox(height: 8.0),
          _LoginButton(),
        ],
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpFirstNameChanged(value)),
          decoration: InputDecoration(
            labelText: 'First Name',
            errorText: state.isFailure ? 'Invalid input' : null,
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpLastNameChanged(value)),
          decoration: InputDecoration(
            labelText: 'Last Name',
            errorText: state.isFailure ? 'Invalid input' : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpEmailChanged(value)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.isFailure ? 'Invalid input' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpPasswordChanged(value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.isFailure ? 'Invalid input' : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return state.isSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () => context.read<SignUpBloc>().add(SignUpSubmitted()),
          child: Text('Sign Up'),
        );
      },
    );
  }
}

class _SignUpStateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.isSuccess) {
          return Text('Sign Up Successful!', style: TextStyle(color: Colors.green));
        } else if (state.isFailure) {
          return Text('Sign Up Failed!', style: TextStyle(color: Colors.red));
        }
        return Container();
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Text('Already have an account? Login'),
    );
  }
}
