import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/DepartmentListModel.dart';
part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(DepartmentInitial());

  ApiManager apiManager = ApiManager();

  fetchDepartment() async {
    emit(DepartmentLoading());
    try {
      Response response;
      response = await apiManager.postWithoutRequest(Config.baseUrl + Routes.departmentList);

      if (response.statusCode == 200) {
        print('department response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of DepartmentListModel objects
        List<DepartmentListModel> departmentList = jsonList
            .map((jsonItem) => DepartmentListModel.fromJson(jsonItem))
            .toList();

        print('Parsed department list: $departmentList');

        // Emit the loaded state with the list of departments
        emit(DepartmentLoaded(DepartmentList: departmentList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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
