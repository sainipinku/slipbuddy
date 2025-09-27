import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/AppointStatusUpdateModel.dart';
import 'package:slipbuddy/models/AppointmentModel.dart';
import 'package:slipbuddy/models/DepartmentListModel.dart';
part 'appointmentstatus_state.dart';

class AppointmentStatusCubit extends Cubit<AppointmentStatusState> {
  AppointmentStatusCubit() : super(AppointmentStatusInitial());

  ApiManager apiManager = ApiManager();

  fetchAppointmentStatus(var body) async {
    emit(AppointmentStatusLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.AppointStatusUpdate);

      if (response.statusCode == 200) {
        print('Appointment response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        var jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of AppointmentListModel objects
        AppointStatusUpdateModel appointmentList = AppointStatusUpdateModel.fromJson(jsonList);

        print('Parsed Appointment list: $appointmentList');

        // Emit the loaded state with the list of Appointments
        emit(AppointmentStatusLoaded(appointmentList: appointmentList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(AppointmentStatusLogout());
      } else {
        emit(AppointmentStatusFailed());
      }
    } on SocketException {
      emit(AppointmentStatusInternetError());
    } on TimeoutException {
      emit(AppointmentStatusTimeout());
    } catch (e) {
      print('Error fetching Appointments: $e');
      emit(AppointmentStatusFailed());
    }
  }

}
