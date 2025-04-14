
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:slipbuddy/constants/api_manager.dart';
import 'package:slipbuddy/constants/config.dart';
import 'package:slipbuddy/models/DoctorScheduleDetailsModel.dart';

part 'doctor_schedule_details_state.dart';

class DoctorScheduleDetailsCubit extends Cubit<DoctorScheduleDetailsState> {
  DoctorScheduleDetailsCubit () : super (DoctorScheduleDetailsInitial());

  ApiManager apiManager = ApiManager();

  fetchDoctorScheduleDetails(var body) async {
    emit(DoctorScheduleDetailsLoading());
    try {
      Response response;
      response = await apiManager.postRequest(body,Config.baseUrl + Routes.getdoctorbyid);

      if (response.statusCode == 200) {
        print('DoctorScheduleDetails response----------------${response.statusCode}');

        // Parse the JSON response as a list of dynamic objects
        List<dynamic> jsonList = jsonDecode(response.body);

        // Convert the list of dynamic objects into a list of DoctorScheduleDetailsListModel objects
        List<DoctorScheduleDetailsModel> DoctorScheduleDetailsList = jsonList
            .map((jsonItem) => DoctorScheduleDetailsModel.fromJson(jsonItem))
            .toList();



        // Emit the loaded state with the list of DoctorScheduleDetailss
        emit(DoctorScheduleDetailsLoaded(DoctorScheduleDetailsList: DoctorScheduleDetailsList));
        print('Parsed DoctorScheduleDetails list: ${DoctorScheduleDetailsList[0].description}');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(DoctorScheduleDetailsLogout());
      } else {
        emit(DoctorScheduleDetailsFailed());
      }
    } on SocketException {
      emit(DoctorScheduleDetailsInternetError());
    } on TimeoutException {
      emit(DoctorScheduleDetailsTimeout());
    } catch (e) {
      print('Error fetching DoctorScheduleDetailss: $e');
      emit(DoctorScheduleDetailsFailed());
    }
  }

}
