import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/UpdateUserProfileModel.dart';
import 'package:slipbuddy/models/UserProfileModel.dart';
part 'updateuserprofile_state.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileState> {
  UpdateUserProfileCubit() : super(UpdateUserProfileInitial());

  ApiManager apiManager = ApiManager();

  fetchUpdateUserProfileData(Map body) async {
    emit(UpdateUserProfileLoading());
    try {

      final userProfileResponse = await apiManager.postRequest(body,Config.baseUrl + Routes.profileupdate);
      if (userProfileResponse.statusCode == 200 ) {
        print('UpdateUserProfileResponse response----------------${userProfileResponse.statusCode}');
        UpdateUserProfileModel updateUserProfileModel = UpdateUserProfileModel.fromJson(jsonDecode(userProfileResponse.body));
        print('updateUserProfileModel body----------------${body}');
        print('updateUserProfileModel response----------------${updateUserProfileModel}');
        emit(UpdateUserProfile(updateUserProfileModel: updateUserProfileModel));
      } else if (userProfileResponse.statusCode == 401 || userProfileResponse.statusCode == 403) {
        emit(UpdateUserProfileLogout());
      } else {
        emit(UpdateUserProfileFailed());
      }
    } on SocketException {
      emit(UpdateUserProfileInternetError());
    } on TimeoutException {
      emit(UpdateUserProfileTimeout());
    } catch (e) {
      print('Error fetching departments: $e');
      emit(UpdateUserProfileFailed());
    }
  }

}
