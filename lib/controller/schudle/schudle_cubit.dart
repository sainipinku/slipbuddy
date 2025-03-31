import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/schudle_model.dart';
part 'schudle_state.dart';

class SchudleCubit extends Cubit<SchudleState> {
  SchudleCubit () : super (SchudleInitial());

  ApiManager apiManager = ApiManager();

  verifyOtp(Map map) async {
    emit(SchudleLoading());
    try {
      var response = await apiManager.postRequest(
          map, Config.baseUrl + Routes.AppointRegister);
      debugPrint("response${response.body}");
      if (response.statusCode == 200) {
        emit(SchudleSuccess());
      } else if (response.statusCode == 403) {
        emit(SchudleOnHold());
      } else {
        emit(SchudleFailed());
      }
    } on SocketException {
      emit(SchudleInternetError());
    } on TimeoutException {
      emit(SchudleTimeout());
    } catch (e) {
      emit(SchudleFailed());
    }
  }
}
