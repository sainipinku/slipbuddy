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

part 'search_location_state.dart';

class SearchLocationCubit extends Cubit<SearchLocationState> {
  SearchLocationCubit() : super(SearchLocationInitial());

  final ApiManager apiManager = ApiManager();

  /// 🔹 Fetch Recent Search Locations API
  Future<void> fetchSearchLocation(Map<String, dynamic> body) async {
    emit(SearchLocationLoading());
    try {
      final Response response = await apiManager.postRequest(
        body,
        Config.baseUrl + Routes.getRecentsSearches,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetRecentSearchModel> recentSearchList = jsonList
            .map((jsonItem) => GetRecentSearchModel.fromJson(jsonItem))
            .toList();

        emit(SearchSearchLocationLoaded(recentSearchList: recentSearchList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(SearchLocationLogout());
      } else {
        emit(SearchLocationFailed());
      }
    } on SocketException {
      emit(SearchLocationInternetError());
    } on TimeoutException {
      emit(SearchLocationTimeout());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Recent Search: $e');
      }
      emit(SearchLocationFailed());
    }
  }

  Future<void> addRecentLocation(Map<String, dynamic> body) async {
    emit(SearchLocationLoading());
    try {
      final Response response = await apiManager.postRequest(
        body,
        Config.baseUrl + Routes.addrecentsearch,
      );

      if (response.statusCode == 200) {
        emit(AddRecentSearchLocationSuccess());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(SearchLocationLogout());
      } else {
        emit(SearchLocationFailed());
      }
    } on SocketException {
      emit(SearchLocationInternetError());
    } on TimeoutException {
      emit(SearchLocationTimeout());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching SearchLocation: $e');
      }
      emit(SearchLocationFailed());
    }
  }
}
