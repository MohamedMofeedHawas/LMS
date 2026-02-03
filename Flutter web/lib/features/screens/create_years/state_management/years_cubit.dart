
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/create_years/state_management/years_states.dart';
import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';

class YearCubit extends Cubit<YearState> {
  YearCubit() : super(YearInitial());

  final Dio dio = Dio(BaseOptions(baseUrl: ApiResources.apiUrl));

  Future<void> createYear(
      TextEditingController fullNameController,
      TextEditingController descriptionController,
      String departmentName,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      emit(YearLoading());

      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(YearError("You are not authorized. Token missing."));
        return;
      }

      final data = {
        "name": fullNameController.text.trim(),
        "description": descriptionController.text.trim(),
        "departmentName": departmentName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };

      final response = await dio.post(
        ApiResources.createYearEndPoint,
        data: data,
        options: Options(
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(YearSuccess("Year created successfully"));
        fullNameController.clear();
        descriptionController.clear();
        departmentName = "Select Department";
        startDate = DateTime.now();
        endDate = DateTime.now();
      } else {
        emit(YearError("Failed to create year. Status: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      String errorMsg = "An unknown error occurred.";
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? e.response?.statusMessage ?? "Server Error";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = "Connection Error. Please check your network.";
      }
      emit(YearError(errorMsg));
    } catch (e) {
      emit(YearError(e.toString()));
    }
  }
}