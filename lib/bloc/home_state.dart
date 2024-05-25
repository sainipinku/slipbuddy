part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Patient> patientsNeedingAttention;

  const HomeLoaded({required this.patientsNeedingAttention});

  @override
  List<Object> get props => [patientsNeedingAttention];
}

class HomeError extends HomeState {}
