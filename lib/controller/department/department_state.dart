part of 'department_cubit.dart';

@immutable
sealed class DepartmentState {}

final class DepartmentInitial extends DepartmentState {}

final class DepartmentLoading extends DepartmentState {}

final class DepartmentLoaded extends DepartmentState {
  final List<DepartmentListModel> DepartmentList;

  DepartmentLoaded({required this.DepartmentList});
}

final class DepartmentFailed extends DepartmentState {}

final class DepartmentInternetError extends DepartmentState {}

final class DepartmentTimeout extends DepartmentState {}

final class DepartmentLogout extends DepartmentState {}
