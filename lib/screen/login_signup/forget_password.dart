import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/forget_password_bloc.dart';
import '../../bloc/forget_password_event.dart';
import '../../bloc/forget_password_state.dart';


class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
      body: BlocProvider(
        create: (context) => ForgetPasswordBloc(),
        child: ForgetPasswordForm(),
      ),
    );
  }
}

class ForgetPasswordForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              return TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state is EmailInvalid ? 'Invalid email' : null,
                ),
                onChanged: (value) {
                  context.read<ForgetPasswordBloc>().add(EmailChanged(value));
                },
              );
            },
          ),
          SizedBox(height: 16.0),
          BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
            listener: (context, state) {
              if (state is ForgetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Reset link sent to your email.'),
                ));
              } else if (state is ForgetPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
              }
            },
            builder: (context, state) {
              return state is ForgetPasswordLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (state is EmailValid) {
                    context.read<ForgetPasswordBloc>().add(SubmitEmail());
                  }
                },
                child: Text('Submit'),
              );
            },
          ),
        ],
      ),
    );
  }
}
