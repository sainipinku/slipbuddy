import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/DoctorModel.dart';
part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());

  ApiManager apiManager = ApiManager();

  fetchDoctor(var body) async {
    emit(DoctorLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.doctorList);

      if (response.statusCode == 200) {
        print('Doctor response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of DoctorListModel objects
        List<DoctorModel> DoctorList = jsonList
            .map((jsonItem) => DoctorModel.fromJson(jsonItem))
            .toList();

        print('Parsed Doctor list: $DoctorList');

        // Emit the loaded state with the list of Doctors
        emit(DoctorLoaded(DoctorList: DoctorList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(DoctorLogout());
      } else {
        emit(DoctorFailed());
      }
    } on SocketException {
      emit(DoctorInternetError());
    } on TimeoutException {
      emit(DoctorTimeout());
    } catch (e) {
      print('Error fetching Doctors: $e');
      emit(DoctorFailed());
    }
  }

}
