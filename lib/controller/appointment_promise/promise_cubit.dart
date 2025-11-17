import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/AppointmentPromiseModel.dart';
import 'package:slipbuddy/models/AppointmentRegisterModel.dart';
part 'promise_state.dart';

class PromiseCubit extends Cubit<PromiseState> {
  PromiseCubit () : super (PromiseInitial());

  ApiManager apiManager = ApiManager();

  promiseList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
   var body = {"MsrNo" : userToken};
    emit(PromiseLoading());
    try {
      var response = await apiManager.postRequest(
          body, Config.baseUrl + Routes.promiseList);

      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);

        List<dynamic> jsonList = jsonBody;

        // Convert the list of dynamic objects into a list of DepartmentListModel objects
        List<AppointmentPromiseModel> appointmentPromiseList = jsonList
            .map((jsonItem) => AppointmentPromiseModel.fromJson(jsonItem))
            .toList();
        emit(PromiseSuccess(appointmentPromiseList: appointmentPromiseList));
      } else if (response.statusCode == 403) {
        emit(PromiseOnHold());
      } else {
        emit(PromiseFailed());
      }
    } on SocketException {
      emit(PromiseInternetError());
    } on TimeoutException {
      emit(PromiseTimeout());
    } catch (e) {
      emit(PromiseFailed());
    }
  }
}
