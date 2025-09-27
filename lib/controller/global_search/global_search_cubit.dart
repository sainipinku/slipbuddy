import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/DoctorModel.dart';

part 'global_search_state.dart';

class GlobalSearchCubit extends Cubit<GlobalSearchState> {
  GlobalSearchCubit() : super(GlobalSearchInitial());

  ApiManager apiManager = ApiManager();

  fetchGlobalSearch(var body) async {
    emit(GlobalSearchLoading());
    try {
      Response response = await apiManager.postRequest(
        body,
        Config.baseUrl + Routes.searchbytext,
      );

      debugPrint("Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        List<dynamic> jsonList = [];

        // Case 1: Response is already a list
        if (decoded is List) {
          jsonList = decoded;
        }

        // Case 2: Response is a map and contains "data"
        else if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
          jsonList = decoded["data"] ?? [];
        }

        // Convert into DoctorModel list
        List<DoctorModel> doctorList = jsonList
            .map((jsonItem) => DoctorModel.fromJson(jsonItem))
            .toList();

        debugPrint("Parsed Doctor list: $doctorList");

        emit(GlobalSearchLoaded(doctorList: doctorList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(GlobalSearchLogout());
      } else {
        emit(GlobalSearchFailed());
      }
    } on SocketException {
      emit(GlobalSearchInternetError());
    } on TimeoutException {
      emit(GlobalSearchTimeout());
    } catch (e, s) {
      debugPrint('Error fetching GlobalSearchs: $e');
      debugPrintStack(stackTrace: s);
      emit(GlobalSearchFailed());
    }
  }
}
