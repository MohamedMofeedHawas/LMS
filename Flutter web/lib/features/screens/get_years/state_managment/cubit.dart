import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/get_department/state_mangment/states.dart';
import 'package:lms/features/screens/get_department/model/model.dart';
import 'package:lms/features/screens/get_years/state_managment/states.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../model.dart';

class YearsCubitDrop extends Cubit<YearsStateDrop> {
  YearsCubitDrop() : super(YearInitialState());

  Future<void> fetchYears() async {
    emit(YearLoadingState());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(YearsErrorState("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();
      final response = await dio.get(
        "https://skylearn.runasp.net/api/years",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.data is List) {
        final List yearsJson = response.data;
        final years = yearsJson
            .map((e) => GetYearModel.fromJson(e))
            .toList();

        emit(YearLoadedState(years));
      } else {
        emit(YearsErrorState("Failed to load years. Status: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      String errorMessage = "Failed to load departments";
      if (e.response != null) {
        errorMessage = "Server Error: ${e.response?.statusCode} - ${e.response?.statusMessage}";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = "Connection Error. Please check the API URL or your network.";
      }
      emit(YearsErrorState(errorMessage));
    } catch (e) {
      print("Unexpected Error: $e");
      emit(YearsErrorState("An unexpected error occurred."));
    }
  }
}