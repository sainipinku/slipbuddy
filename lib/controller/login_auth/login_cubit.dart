
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';

part 'login_state.dart';
class LoginCubit extends Cubit<LoginState> {

  LoginCubit () : super (LoginInitial());

  ApiManager apiManager = ApiManager();

  getOtp(Map map) async {
    emit(LoginLoading());
    try {
      var response = await apiManager.postRequest(
          map, Config.baseUrl + Routes.getOtp);
      debugPrint("response${response.body}");
      if (response.statusCode == 200) {
        emit(LoginSuccess());
      } else if (response.statusCode == 403) {
        emit(LoginOnHold());
      } else {
        emit(LoginFailed());
      }
    } on SocketException {
      emit(LoginInternetError());
    } on TimeoutException {
      emit(LoginTimeout());
    } catch (e) {
      emit(LoginFailed());
    }
  }
  getDeleteAccount(Map map) async {
    emit(LoginLoading());
    try {
      var response = await apiManager.postRequest(
          map, Config.baseUrl + Routes.ProfileDelete);
      debugPrint("response${response.body}");
      if (response.statusCode == 200) {
        emit(LoginSuccess());
      } else if (response.statusCode == 403) {
        emit(LoginOnHold());
      } else {
        emit(LoginFailed());
      }
    } on SocketException {
      emit(LoginInternetError());
    } on TimeoutException {
      emit(LoginTimeout());
    } catch (e) {
      emit(LoginFailed());
    }
  }


}