import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/cons/context/navigation_key.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../ActivateAccountScreen/view.dart';

import '../../login/view.dart';
import '../user_model/data.dart';
import 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit() : super(VerifyInitialState());

  Future<void> postVerifyData(
      TextEditingController emailController,
      BuildContext context,
      ) async {
    emit(LoadingVerifyState());

    try {
      final response = await Dio(
        BaseOptions(baseUrl: ApiResources.apiUrl),
      ).post(
        ApiResources.verifyUserEmailEndPoint,
        data: {
          "email": emailController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final model = UserStatusModel.fromJson(response.data);

        await VerifyStorageHelper.saveVerifyData(model);

        emailController.clear();
        emit(VerifySuccessState());


        if (!model.exists) {
          _showSnackBar(
            message:
            "This email address does not exist. Please contact the administrator.",
            isError: true,
          );
          return;
        }


        if (model.exists && !model.isActivated) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => const ActivateAccountScreen(),
            ),
          );
          return;
        }


        if (model.exists && model.isActivated) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
          return;
        }
      } else {
        emit(VerifyErrorState());
        _showSnackBar(
          message: response.data["message"] ?? "Verify failed",
          isError: true,
        );
      }
    } on DioException catch (e) {
      emit(VerifyErrorState());

      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server took too long to respond";
      }

      _showSnackBar(message: errorMessage, isError: true);
    } catch (e) {
      emit(VerifyErrorState());
      _showSnackBar(
        message: "Unexpected error: $e",
        isError: true,
      );
    }
  }

  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor:
        isError ? Colors.redAccent : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }
}
