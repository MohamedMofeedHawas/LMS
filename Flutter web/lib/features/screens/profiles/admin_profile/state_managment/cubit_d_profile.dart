import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lms/features/screens/profiles/admin_profile/model/view.dart';
import 'package:lms/features/screens/profiles/admin_profile/state_managment/state_d_profile.dart';

import '../../../../../core/cons/api_helper_resources/api_resources.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';


class AdminProfileCubit extends Cubit<AdminProfileState> {
  AdminProfileCubit() : super(AdminProfileInitial());

  Future<void> getProfile() async {
    emit(AdminProfileLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(AdminProfileError(message: "You are not authorized. Token missing."));
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
        final model = AdminProfileUser.fromJson(response.data);
        emit(AdminProfileLoaded(profile: model));
      } else {
        emit(AdminProfileError(
            message: response.data["message"] ?? "Failed to load profile"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      }

      emit(AdminProfileError(message: errorMessage));
    } catch (e) {
      emit(AdminProfileError(message: "Unexpected error: $e"));
    }
  }
}
