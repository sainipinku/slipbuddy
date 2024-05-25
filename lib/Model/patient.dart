import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String condition;
  final bool needsAttention;

  Patient({
    required this.id,
    required this.name,
    required this.condition,
    required this.needsAttention,
  });

  @override
  List<Object?> get props => [id, name, condition, needsAttention];
}
