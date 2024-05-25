import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(const RoleState('')) {
    on<RoleSelected>((event, emit) {
      emit(RoleState(event.role));
    });
  }
}
