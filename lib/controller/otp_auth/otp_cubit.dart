
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';

part 'otp_state.dart';
class OtpCubit extends Cubit<OtpState> {

  OtpCubit () : super (OtpInitial());

  ApiManager apiManager = ApiManager();

  verifyOtp(Map map) async {
    emit(OtpLoading());
    try {
      var response = await apiManager.postRequest(
          map, Config.baseUrl + Routes.verifyOtp);

      if (response.statusCode == 200) {

        if(json.decode(response.body)['status'] == 'True'){
          SharedPref.setUserID(json.decode(response.body)['Msrno'].toString());
          emit(OtpSuccess());
        }else {
          emit(InvalidOtpSuccess());
        }

      } else if (response.statusCode == 403) {
        emit(OtpOnHold());
      } else {
        emit(OtpFailed());
      }
    } on SocketException {
      emit(OtpInternetError());
    } on TimeoutException {
      emit(OtpTimeout());
    } catch (e) {
      emit(OtpFailed());
    }
  }


}