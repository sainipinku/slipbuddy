import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/bloc/doctor_dashboard_event.dart';
import 'package:slipbuddy/bloc/doctor_dashboard_state.dart';
import '../Repositories/appointment_repository.dart';

class DoctorDashboardBloc extends Bloc<DoctorDashboardEvent, DoctorDashboardState> {
  final AppointmentRepository repository;

  DoctorDashboardBloc({required this.repository}) : super(DoctorDashboardLoading());

  @override
  Stream<DoctorDashboardState> mapEventToState(DoctorDashboardEvent event) async* {
    if (event is LoadDoctorDashboard) {
      yield* _mapLoadDoctorDashboardToState();
    }
  }

  Stream<DoctorDashboardState> _mapLoadDoctorDashboardToState() async* {
    yield DoctorDashboardLoading();
    try {
      final upcomingAppointments = await repository.fetchAppointments('upcoming');
      yield DoctorDashboardLoaded(upcomingAppointments: upcomingAppointments);
    } catch (_) {
      yield DoctorDashboardError();
    }
  }
}
