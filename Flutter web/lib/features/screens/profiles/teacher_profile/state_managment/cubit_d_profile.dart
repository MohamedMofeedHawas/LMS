import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lms/features/screens/profiles/admin_profile/model/view.dart';
import 'package:lms/features/screens/profiles/admin_profile/state_managment/state_d_profile.dart';
import 'package:lms/features/screens/profiles/teacher_profile/state_managment/state_d_profile.dart';

import '../../../../../core/cons/api_helper_resources/api_resources.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../model/view.dart';


class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  TeacherProfileCubit() : super(TeacherProfileInitial());

  Future<void> getProfile() async {
    emit(TeacherProfileLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit( TeacherProfileError(message: "You are not authorized. Token missing."));
        return;
      }

      final response = await Dio(BaseOptions(
        baseUrl: ApiResources.apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
        },
      )).get(ApiResources.getProfileEndpoint);

      if (response.statusCode == 200) {
        final model = TeacherProfileUser.fromJson(response.data);
        emit(TeacherProfileLoaded(profile: model));
      } else {
        emit(TeacherProfileError(
            message: response.data["message"] ?? "Failed to load profile"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      }

      emit(TeacherProfileError(message: errorMessage));
    } catch (e) {
      emit(TeacherProfileError(message: "Unexpected error: $e"));
    }
  }
}
