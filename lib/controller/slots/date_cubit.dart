import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/DoctorModel.dart';
import 'package:slipbuddy/models/SlotsDateModel.dart';
import 'package:slipbuddy/models/SlotsModel.dart';
part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial());

  ApiManager apiManager = ApiManager();

  fetchDateSlots(var body) async {
    emit(DateLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.dateSlotsList);

      if (response.statusCode == 200) {
        print('Date response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of DateListModel objects
        List<SlotsDateModel> dateSlotsList = jsonList
            .map((jsonItem) => SlotsDateModel.fromJson(jsonItem))
            .toList();

        print('Parsed Slots list: $dateSlotsList');

        // Emit the loaded state with the list of Slotss
        emit(DateSlotsLoaded(dateSlotsList: dateSlotsList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(DateLogout());
      } else {
        emit(DateFailed());
      }
    } on SocketException {
      emit(DateInternetError());
    } on TimeoutException {
      emit(DateTimeout());
    } catch (e) {
      print('Error fetching Dates: $e');
      emit(DateFailed());
    }
  }

}
