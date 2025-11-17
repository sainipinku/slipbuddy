import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/GetRecentSearchModel/GetLocationModel.dart';
import 'package:slipbuddy/models/GetRecentSearchModel/GetRecentSearchModel.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  final ApiManager apiManager = ApiManager();

  /// 🔹 Fetch Location List API
  Future<void> fetchLocation(Map<String, dynamic> body) async {
    emit(LocationLoading());
    try {
      final Response response = await apiManager.postRequest(
        body,
        Config.baseUrl + Routes.getLocation,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetLocationModel> locationList = jsonList
            .map((jsonItem) => GetLocationModel.fromJson(jsonItem))
            .toList();

        emit(LocationLoaded(locationList: locationList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(LocationLogout());
      } else {
        emit(LocationFailed());
      }
    } on SocketException {
      emit(LocationInternetError());
    } on TimeoutException {
      emit(LocationTimeout());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Location: $e');
      }
      emit(LocationFailed());
    }
  }

  /// 🔹 Fetch Location List API
  Future<void> addLocation(Map<String, dynamic> body) async {
    emit(LocationLoading());
    try {
      final Response response = await apiManager.postRequest(
        body,
        Config.baseUrl + Routes.AddUserAdress,
      );

      if (response.statusCode == 200) {
        emit(AddSuccess());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(LocationLogout());
      } else {
        emit(LocationFailed());
      }
    } on SocketException {
      emit(LocationInternetError());
    } on TimeoutException {
      emit(LocationTimeout());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Location: $e');
      }
      emit(LocationFailed());
    }
  }

}
