import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/cons/context/navigation_key.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../courses/admin/view.dart';
import '../../courses/student/view.dart';
import '../../courses/teacher/view.dart';
import '../../login/view.dart';
import '../user_model/data.dart';
import 'activate_state.dart';

class ActivateCubit extends Cubit<ActivateState> {

  ActivateCubit() : super(ActivateInitialState());

  Future<void> postActivateData(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmedPasswordController,
      BuildContext context,
      ) async {
    emit(LoadingSActivateState());

    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: ApiResources.apiUrl,
          validateStatus: (status) => true,
        ),
      ).post(
        ApiResources.activateUserEmailEndPoint,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "email": emailController.text,
          "password": passwordController.text,
          "confirmPassword": confirmedPasswordController.text,
        },
      );

      debugPrint("ACTIVATE STATUS CODE: ${response.statusCode}");
      debugPrint("ACTIVATE RESPONSE DATA: ${response.data}");

      if (response.statusCode == 200) {
        final model = ActivateUserModel.fromJson(response.data);

        final token = response.data['token'];
        if (token != null && token.toString().isNotEmpty) {
          await TokenStorageHelper.saveTokenSecure(token);
        }

        await ActivateUserPrefs.saveActivateUserData(model);

        emit(ActivateSuccessState());

        passwordController.clear();
        emailController.clear();
        confirmedPasswordController.clear();

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              response.data["message"] ?? "Activation successful",
            ),
            backgroundColor: Colors.green,
          ),
        );

        if (model.user.role == "Student"){
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  StudentCourseScreen() ,));
        }else if (model.user.role == "Instructor"){
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  TeacherCourseScreen() ,));
        } else {
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  AdminCourseScreen() ,));
        }

      } else {
        emit(ActivateErrorState());

        debugPrint("ACTIVATE BACKEND ERROR:");
        debugPrint("Status: ${response.statusCode}");
        debugPrint("Message: ${response.data}");

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              (response.data is Map && response.data["message"] != null)
                  ? response.data["message"]
                  : "Activation failed",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } on DioException catch (e) {
      emit(ActivateErrorState());

      debugPrint("DIO ERROR TYPE: ${e.type}");
      debugPrint("DIO ERROR MESSAGE: ${e.message}");
      debugPrint("DIO ERROR RESPONSE: ${e.response?.data}");
      debugPrint("DIO STATUS CODE: ${e.response?.statusCode}");

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data?["message"] ?? "Network error occurred",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      emit(ActivateErrorState());

      debugPrint("UNEXPECTED ERROR: $e");

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
