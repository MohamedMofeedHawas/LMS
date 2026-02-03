import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/features/screens/get_squadron/model/view.dart';
import 'package:lms/features/screens/get_squadron/state_mangment/states.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../../../core/cons/api_helper_resources/api_resources.dart';

class SquadronsCubitDrop extends Cubit<GetSquadronsState> {
  SquadronsCubitDrop() : super(GetSquadronsInitial());

  Future<void> fetchSquadrons() async {
    emit(GetSquadronsLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(GetSquadronsError("Unauthorized: Please login again."));
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

        emit(GetSquadronsLoaded(squadrons));
      } else {
        emit(GetSquadronsError("Failed to load squadrons. Status: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      String errorMessage = "Failed to load squadrons";
      if (e.response != null) {
        errorMessage = "Server Error: ${e.response?.statusCode} - ${e.response?.statusMessage}";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = "Connection Error. Please check the API URL or your network.";
      }
      emit(GetSquadronsError(errorMessage));
    } catch (e) {
      print("Unexpected Error: $e");
      emit(GetSquadronsError("An unexpected error occurred."));
    }
  }
}