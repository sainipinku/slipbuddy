import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/controller/login_auth/login_cubit.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
  ];
}
