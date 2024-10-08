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
part 'slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  SlotsCubit() : super(SlotsInitial());

  ApiManager apiManager = ApiManager();

  fetchSlots(var body) async {
    emit(SlotsLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.slotsList);

      if (response.statusCode == 200) {
        print('Slots response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of SlotsListModel objects
        List<SlotsModel> SlotsList = jsonList
            .map((jsonItem) => SlotsModel.fromJson(jsonItem))
            .toList();

        print('Parsed Slots list: $SlotsList');

        // Emit the loaded state with the list of Slotss
        emit(SlotsLoaded(SlotsList: SlotsList));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(SlotsLogout());
      } else {
        emit(SlotsFailed());
      }
    } on SocketException {
      emit(SlotsInternetError());
    } on TimeoutException {
      emit(SlotsTimeout());
    } catch (e) {
      print('Error fetching Slotss: $e');
      emit(SlotsFailed());
    }
  }

}
