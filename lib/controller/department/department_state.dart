part of 'department_cubit.dart';

@immutable
sealed class DepartmentState {}

final class DepartmentInitial extends DepartmentState {}

final class DepartmentLoading extends DepartmentState {}

final class DepartmentLoaded extends DepartmentState {
  final List<DepartmentListModel> DepartmentList;

  DepartmentLoaded({required this.DepartmentList});
}
final class BannerImageLoaded extends DepartmentState {
  final List<BannerModel> bannerImagesList;

  BannerImageLoaded({required this.bannerImagesList});
}
final class CompletedDoctorListLoaded extends DepartmentState {
  final List<CompletedDoctorListModel> completedDoctorList;

  CompletedDoctorListLoaded({required this.completedDoctorList});
}
class MultipleDataLoaded extends DepartmentState {
  final List<DepartmentListModel> departmentList;
  final List<BannerModel> bannerImagesList;
  final List<CompletedDoctorListModel> completedDoctorList;

  MultipleDataLoaded({required this.departmentList, required this.bannerImagesList,required this.completedDoctorList});
}
final class DepartmentFailed extends DepartmentState {}

final class DepartmentInternetError extends DepartmentState {}

final class DepartmentTimeout extends DepartmentState {}

final class DepartmentLogout extends DepartmentState {}
