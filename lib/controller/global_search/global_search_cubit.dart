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
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.searchbytext);

      if (response.statusCode == 200) {
        print('Doctor response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of DoctorListModel objects
        List<DoctorModel> DoctorList = jsonList
            .map((jsonItem) => DoctorModel.fromJson(jsonItem))
            .toList();

        print('Parsed Doctor list: ${jsonEncode(DoctorList.toString())}');

        // Emit the loaded state with the list of Doctors
        emit(GlobalSearchLoaded(DoctorList: DoctorList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(GlobalSearchLogout());
      } else {
        emit(GlobalSearchFailed());
      }
    } on SocketException {
      emit(GlobalSearchInternetError());
    } on TimeoutException {
      emit(GlobalSearchTimeout());
    } catch (e) {
      print('Error fetching GlobalSearchs: $e');
      emit(GlobalSearchFailed());
    }
  }

}
