import 'package:equatable/equatable.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();
}

class RoleSelected extends RoleEvent {
  final String role;

  const RoleSelected(this.role);

  @override
  List<Object> get props => [role];
}
