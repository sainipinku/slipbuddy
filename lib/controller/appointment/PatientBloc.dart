import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/controller/appointment/PatientEvent.dart';
import 'package:slipbuddy/controller/appointment/PatientState.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  PatientBloc() : super(PatientState(patientName: '')) {
    on<UpdatePatientName>((event, emit) {
      emit(state.copyWith(patientName: event.name));
    });
  }
}
