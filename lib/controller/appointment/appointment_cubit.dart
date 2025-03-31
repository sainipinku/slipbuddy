import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/AppointmentModel.dart';
import 'package:slipbuddy/models/DepartmentListModel.dart';
part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  ApiManager apiManager = ApiManager();

  fetchAppointment(var body) async {
    emit(AppointmentLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.getAppointment);

      if (response.statusCode == 200) {
        print('Appointment response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of AppointmentListModel objects
        List<AppointmentModel> appointmentList = jsonList
            .map((jsonItem) => AppointmentModel.fromJson(jsonItem))
            .toList();

        print('Parsed Appointment list: $appointmentList');

        // Emit the loaded state with the list of Appointments
        emit(AppointmentLoaded(appointmentList: appointmentList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(AppointmentLogout());
      } else {
        emit(AppointmentFailed());
      }
    } on SocketException {
      emit(AppointmentInternetError());
    } on TimeoutException {
      emit(AppointmentTimeout());
    } catch (e) {
      print('Error fetching Appointments: $e');
      emit(AppointmentFailed());
    }
  }

}
