import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/features/screens/profiles/student_profile/state_mangement/states.dart';

import '../../../../../core/cons/api_helper_resources/api_resources.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../ProfileModel/view.dart';


class StudentProfileCubit extends Cubit<StudentProfileState> {
  StudentProfileCubit() : super(StudentProfileInitial());

  Future<void> getProfile() async {
    emit(StudentProfileLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(StudentProfileError(message: "You are not authorized. Token missing."));
        return;
      }

      final response = await Dio(BaseOptions(
        baseUrl: ApiResources.apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      )).get(ApiResources.getProfileEndpoint);

      if (response.statusCode == 200) {
        final model = StudentProfileModel.fromJson(response.data);
        emit(StudentProfileLoaded(profile: model));
      } else {
        emit(StudentProfileError(
            message: response.data["message"] ?? "Failed to load profile"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      }

      emit(StudentProfileError(message: errorMessage));
    } catch (e) {
      emit(StudentProfileError(message: "Unexpected error: $e"));
    }
  }
}
