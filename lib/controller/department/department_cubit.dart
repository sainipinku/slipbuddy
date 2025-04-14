import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/BannerModel.dart';
import 'package:slipbuddy/models/CompletedDoctorListModel.dart';
import 'package:slipbuddy/models/DepartmentListModel.dart';
part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(DepartmentInitial());

  ApiManager apiManager = ApiManager();

  fetchDepartment() async {
    emit(DepartmentLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('user_id') ?? '';
      var body = {"msrNo" : userToken};
      final departmentResponse = await apiManager.postWithoutRequest(Config.baseUrl + Routes.departmentList);
      final bannerResponse = await apiManager.postWithoutRequest(Config.baseUrl + Routes.banner_list);
      final completedDoctorResponse = await apiManager.postRequest(body,Config.baseUrl + Routes.getappointmentbymsrno);
      if (departmentResponse.statusCode == 200 || bannerResponse.statusCode == 200 || completedDoctorResponse.statusCode == 200 ) {
        print('completedDoctorResponse response----------------${completedDoctorResponse.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(departmentResponse.body);

        // Convert the list of dynamic objects into a list of DepartmentListModel objects
        List<DepartmentListModel> departmentList = jsonList
            .map((jsonItem) => DepartmentListModel.fromJson(jsonItem))
            .toList();
        List<dynamic> jsonList1 = jsonDecode(bannerResponse.body);

        // Convert the list of dynamic objects into a list of DepartmentListModel objects
        List<BannerModel> bannerImagesList = jsonList1
            .map((jsonItem) => BannerModel.fromJson(jsonItem))
            .toList();
        print('Parsed department list: $departmentList');
        List<dynamic> jsonList3 = jsonDecode(completedDoctorResponse.body);

        // Convert the list of dynamic objects into a list of DepartmentListModel objects
        List<CompletedDoctorListModel> completedDoctorList = jsonList3
            .map((jsonItem1) => CompletedDoctorListModel.fromJson(jsonItem1))
            .toList();
        print('completedDoctorList list: $completedDoctorList');

        // Emit the loaded state with the list of departments
        emit(MultipleDataLoaded(departmentList: departmentList,bannerImagesList: bannerImagesList,completedDoctorList: completedDoctorList));
      } else if (departmentResponse.statusCode == 401 || departmentResponse.statusCode == 403) {
        emit(DepartmentLogout());
      }
      else if (bannerResponse.statusCode == 401 || bannerResponse.statusCode == 403 || departmentResponse.statusCode == 401 || departmentResponse.statusCode == 403 || completedDoctorResponse.statusCode == 401 || completedDoctorResponse.statusCode == 403) {
        emit(DepartmentLogout());
      } else {
        emit(DepartmentFailed());
      }
    } on SocketException {
      emit(DepartmentInternetError());
    } on TimeoutException {
      emit(DepartmentTimeout());
    } catch (e) {
      print('Error fetching departments: $e');
      emit(DepartmentFailed());
    }
  }

}
