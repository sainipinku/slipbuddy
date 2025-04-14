import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/UserProfileModel.dart';
part 'userprofile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  ApiManager apiManager = ApiManager();

  fetchUserProfileData() async {
    emit(UserProfileLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('user_id') ?? '';
      var body = {"MsrNo" : '89'};
      final userProfileResponse = await apiManager.postRequest(body,Config.baseUrl + Routes.getuserprofilebymsrno);
      if (userProfileResponse.statusCode == 200 ) {
        print('userProfileResponse response----------------${userProfileResponse.statusCode}');
        List<dynamic> jsonList = jsonDecode(userProfileResponse.body);
        List<UserProfileModel> userList = jsonList
            .map((item) => UserProfileModel.fromJson(item))
            .toList();
        print('userProfileResponse response----------------${userList}');
        emit(MultipleDataLoaded(userList: userList));
      } else if (userProfileResponse.statusCode == 401 || userProfileResponse.statusCode == 403) {
        emit(UserProfileLogout());
      } else {
        emit(UserProfileFailed());
      }
    } on SocketException {
      emit(UserProfileInternetError());
    } on TimeoutException {
      emit(UserProfileTimeout());
    } catch (e) {
      print('Error fetching departments: $e');
      emit(UserProfileFailed());
    }
  }

}
