import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../User_model/model.dart';
import 'Create_user_state.dart';


class CreateUserCubit extends Cubit<CreateState> {
  CreateUserCubit() : super(CreateUserInitialState());

  Future<void> postCreatedUserData(
      TextEditingController emailController,
      TextEditingController fullNameController,
      TextEditingController nationalIdController,
      TextEditingController genderController,
      DateTime dateOfBirth,
      String city,
      String role,
      BuildContext context, {
        Uint8List? profileImageBytes,
        String? departmentId,
        String? yearId,
        String? squadronId,
      }) async {
    if (emailController.text.trim().isEmpty || fullNameController.text.trim().isEmpty) {
      emit(CreateUserErrorState("Please fill all required fields"));
      return;
    }

    emit(LoadingCreateUserState());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(CreateUserErrorState("Authentication required. Please login first.", statusCode: 401));
        return;
      }

      final formData = FormData.fromMap({
        "Email": emailController.text.trim(),
        "FullName": fullNameController.text.trim(),
        "NationalId": nationalIdController.text.trim(),
        "City": city,
        "Gender": genderController.text.trim(),
        "Role": role,
        "DateOfBirth": dateOfBirth.toIso8601String(),
        if (role == "Student"&&departmentId != null) "DepartmentId": departmentId,
        if ( role == "Student"&&yearId != null) "YearId": yearId,
        if ( role == "Student"&&squadronId != null) "SquadronId": squadronId,
        if (profileImageBytes != null)
          'ImageFile': MultipartFile.fromBytes(
            profileImageBytes,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType("image", "jpeg"),
          ),
      });

      final response = await Dio(BaseOptions(
        baseUrl: ApiResources.apiUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      )).post(
        ApiResources.createUserEndPoint,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = CreateUserModel.fromJson(response.data);
        await UserStorageHelper.saveCreatedUserData(model);
        emit(CreateUserSuccessState(
          statusCode: response.statusCode,
          message: response.data?["message"] ?? "User Created Successfully",
        ));
      } else {
        final errorMsg = response.data?["message"] ?? "Failed to create user";
        emit(CreateUserErrorState(errorMsg, statusCode: response.statusCode));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? e.message ?? "Connection Error";
      emit(CreateUserErrorState(errorMsg));
    } catch (e) {
      emit(CreateUserErrorState(e.toString()));
    }
  }
}