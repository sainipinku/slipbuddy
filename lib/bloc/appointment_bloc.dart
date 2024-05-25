import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../Model/appointment.dart';
import '../Repositories/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;

  AppointmentBloc({required this.repository}) : super(AppointmentLoading());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is LoadAppointments) {
      yield* _mapLoadAppointmentsToState(event);
    }
  }

  Stream<AppointmentState> _mapLoadAppointmentsToState(LoadAppointments event) async* {
    yield AppointmentLoading();
    try {
      final appointments = await repository.fetchAppointments(event.status);
      yield AppointmentLoaded(appointments: appointments);
    } catch (_) {
      yield AppointmentError();
    }
  }
}
