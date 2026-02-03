
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/create_squadron/state_managment/states.dart';
import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';

class SquadronCubit extends Cubit<SquadronState>  {
SquadronCubit( ) : super(SquadronInitial());

  final Dio dio = Dio(BaseOptions(baseUrl: ApiResources.apiUrl));

  Future<void> createSquadron(
      TextEditingController fullNameController,
      TextEditingController descriptionController,

      ) async {
    try {
      emit(SquadronLoading());

      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(SquadronError("You are not authorized. Token missing."));
        return;
      }

      final data = {
        "name": fullNameController.text.trim(),
        "description": descriptionController.text.trim(),

      };

      final response = await dio.post(
        ApiResources.squadronEndPoint,
        data: data,
        options: Options(
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SquadronSuccess("Squadron created successfully"));
        fullNameController.clear();
        descriptionController.clear();

      } else {
        emit(SquadronError("Failed to create Squadron. Status: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      String errorMsg = "An unknown error occurred.";
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? e.response?.statusMessage ?? "Server Error";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = "Connection Error. Please check your network.";
      }
      emit(SquadronError(errorMsg));
    } catch (e) {
      emit(SquadronError(e.toString()));
    }
  }
}