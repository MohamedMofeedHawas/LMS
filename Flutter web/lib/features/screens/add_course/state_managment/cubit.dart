import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lms/features/screens/add_course/state_managment/states.dart';
import '../../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  CreateCourseCubit() : super(CreateCourseInitial());

  final Dio dio = Dio(BaseOptions(baseUrl: ApiResources.apiUrl));

  Future<void> createCourse(
      TextEditingController fullNameController,
      TextEditingController descriptionController,
      String departmentName,
      String yearName,
      TextEditingController creditHoursController,
      Uint8List? imageBytes,
      ) async {
    try {
      emit(CreateCourseLoading());

      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(CreateCourseError("You are not authorized. Token missing."));
        return;
      }

      final formData = FormData.fromMap({
        "Title": fullNameController.text.trim(),
        "Description": descriptionController.text.trim(),
        "DepartmentName": departmentName,
        "YearName": yearName,
        "CreditHours": int.tryParse(creditHoursController.text.trim()) ?? 0,
        if (imageBytes != null)
          "ImageFile": MultipartFile.fromBytes(
            imageBytes,
            filename: "Course.png",
            contentType: MediaType("image", "png"),
          ),
      });

      final response = await dio.post(
        ApiResources.createCourseEndPoint,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateCourseSuccess("Course created successfully"));

      } else {
        emit(CreateCourseError("Failed: ${response.statusMessage}"));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? e.message ?? "Connection Error";
      emit(CreateCourseError(errorMsg));
    } catch (e) {
      emit(CreateCourseError(e.toString()));
    }
  }
}