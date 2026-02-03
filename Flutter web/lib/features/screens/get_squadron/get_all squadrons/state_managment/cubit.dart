import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/get_squadron/get_all%20squadrons/state_managment/states.dart';

import '../../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../model/view.dart';

class AllSquadronCubit extends Cubit<AllSquadronState> {

  AllSquadronCubit() : super(AllSquadronInitial());

  Future<void> fetchSquadrons() async {
    emit(AllSquadronLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(AllSquadronError("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();
      final response = await dio.get(
        "${ApiResources.apiUrl}${ApiResources.squadronEndPoint}",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.data is List) {
        final List squadronsJson = response.data;
        final squadrons = squadronsJson
            .map((e) => SquadronModel.fromJson(e))
            .toList();

        emit(AllSquadronLoaded(squadrons));
      } else {
        emit(AllSquadronError("Failed to load departments. Status: ${response.statusCode}"));
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
      emit(AllSquadronError(errorMessage));
    } catch (e) {
      print("Unexpected Error: $e");
      emit(AllSquadronError("An unexpected error occurred."));
    }
  }

  Future<void> deleteSquadron(int id) async {
    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(AllSquadronError("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();
      final response = await dio.delete(
        "${ApiResources.apiUrl}${ApiResources.squadronEndPoint}/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,

        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        fetchSquadrons();
      } else {
        emit(
          AllSquadronError(
            "Failed to delete squadron. Status: ${response.statusCode}",
          ),
        );
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");

      String errorMessage = "Failed to delete squadron";

      if (e.response != null) {
        errorMessage =
        "Server Error: ${e.response?.statusCode} - ${e.response?.statusMessage}";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
        "Connection Error. Please check the API URL or your network.";
      }

      emit(AllSquadronError(errorMessage));
    } catch (e) {
      print("Unexpected Error: $e");
      emit(AllSquadronError("An unexpected error occurred."));
    }
  }
  Future<void> fetchSquadronById(int id) async {
    emit(GetSquadronByIdLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(AllSquadronError("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();
      final response = await dio.get(
        "${ApiResources.apiUrl}${ApiResources.squadronEndPoint}/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final squadron = SquadronModel.fromJson(response.data);
        emit(GetSquadronByIdLoaded(squadron));
      } else {
        emit(AllSquadronError(
          "Failed to load squadron. Status: ${response.statusCode}",
        ));
      }
    } on DioException catch (e) {
      emit(AllSquadronError(
        e.response != null
            ? "Server Error: ${e.response?.statusCode}"
            : "Connection Error",
      ));
    }
  }
  Future<void> updateSquadron(SquadronModel model) async {
    emit(UpdateSquadronLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(AllSquadronError("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();
      final response = await dio.put(
        "${ApiResources.apiUrl}${ApiResources.squadronEndPoint}/${model.id}",
        data: model.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(UpdateSquadronSuccess("Squadron updated successfully"));
        fetchSquadrons();
      } else {
        emit(AllSquadronError(
          "Failed to update squadron. Status: ${response.statusCode}",
        ));
      }
    } on DioException catch (e) {
      emit(AllSquadronError(
        e.response != null
            ? "Server Error: ${e.response?.statusCode}"
            : "Connection Error",
      ));
    }
  }


}


