import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/controller/appointment/appointment_cubit.dart';
import 'package:slipbuddy/controller/department/department_cubit.dart';
import 'package:slipbuddy/controller/doctor/doctor_cubit.dart';
import 'package:slipbuddy/controller/home/doctor_cubit.dart';
import 'package:slipbuddy/controller/login_auth/login_cubit.dart';
import 'package:slipbuddy/controller/otp_auth/otp_cubit.dart';
import 'package:slipbuddy/controller/schudle/schudle_cubit.dart';
import 'package:slipbuddy/controller/slots/date_cubit.dart';
import 'package:slipbuddy/controller/slots/slots_cubit.dart';


class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
    BlocProvider<OtpCubit>(create: (context) => OtpCubit()),
    BlocProvider<DoctorCubit>(create: (context) => DoctorCubit()),
    BlocProvider<DepartmentCubit>(create: (context) => DepartmentCubit()),
    BlocProvider<SlotsCubit>(create: (context) => SlotsCubit()),
    BlocProvider<DateCubit>(create: (context) => DateCubit()),
    BlocProvider<AppointmentCubit>(create: (context) => AppointmentCubit()),
    BlocProvider<SchudleCubit>(create: (context) => SchudleCubit()),
  ];
}
