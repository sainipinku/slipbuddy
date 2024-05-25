import 'package:equatable/equatable.dart';

class RoleState extends Equatable {
  final String selectedRole;

  const RoleState(this.selectedRole);

  @override
  List<Object> get props => [selectedRole];
}
