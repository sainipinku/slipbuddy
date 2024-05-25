import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../Model/patient.dart';
import '../Repositories/doctor_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DoctorRepository repository;

  HomeBloc({required this.repository}) : super(HomeLoading());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadHome) {
      yield* _mapLoadHomeToState();
    }
  }

  Stream<HomeState> _mapLoadHomeToState() async* {
    yield HomeLoading();
    try {
      final patients = await repository.fetchPatients();
      yield HomeLoaded(patientsNeedingAttention: patients.where((p) => p.needsAttention).toList());
    } catch (_) {
      yield HomeError();
    }
  }
}

