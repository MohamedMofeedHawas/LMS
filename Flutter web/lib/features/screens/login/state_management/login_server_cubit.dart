import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/cons/context/navigation_key.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../courses/admin/view.dart';
import '../../courses/student/view.dart';
import '../../courses/teacher/view.dart';
import '../user_model/data.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  Future<void> postLoginData(
      TextEditingController emailController,
      TextEditingController passwordController,
      BuildContext context,
      ) async {
    emit(LoadingLoginState());

    try {
      final response = await Dio(BaseOptions(baseUrl: ApiResources.apiUrl)).post(
        ApiResources.loginEndPoint,
        data: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      if (response.statusCode == 200 ) {
        emit(LoginSuccessState());
        final model = UserModel.fromJson(response.data);
        await PrefHelper.saveLoginData(model);
        await TokenStorageHelper.saveTokenSecure(model);




        passwordController.clear();
        emailController.clear();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                 Expanded(
                  child: Text(
                      response.data["message"] ?? "Login successful",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: const Duration(seconds: 3),
            elevation: 6,
          ),


        // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        //   SnackBar(
        //     content: Text(response.data["message"] ?? "Login successful",),
        //     backgroundColor: Colors.green,
        //   ),
        );


///ToDO: authentication flow
        if (model.user!.role == "Student"){
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  StudentCourseScreen() ,));
        }else if (model.user!.role == "Instructor"){
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  TeacherCourseScreen() ,));
        } else {
          Navigator.pushReplacement(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>  AdminCourseScreen() ,));
        }



      } else {
        emit(LoginErrorState());
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(response.data["message"] ?? "Invalid email or password"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } on DioException catch (e) {
      emit(LoginErrorState());

      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server took too long to respond";
      }

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      emit(LoginErrorState());
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

}
