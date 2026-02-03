import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/cons/api_helper_resources/api_resources.dart';

import 'package:lms/features/screens/get_department/get_All_departments/state_managments/states.dart';
import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../all_model/model.dart';


class DepartmentsCubit extends Cubit<DepartmentsState> {
  DepartmentsCubit() : super(DepartmentsInitial());

  final Dio dio = Dio(
    BaseOptions(baseUrl: ApiResources.apiUrl),
  );

  Future<void> fetchDepartments() async {
    emit(DepartmentsLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      final response = await dio.get(
        ApiResources.getDepartmentEndPoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final departments = (response.data as List)
          .map((e) => GetAllDepartmentModel.fromJson(e))
          .toList();

      emit(DepartmentsLoaded(departments));
    } catch (e) {
      emit(DepartmentsError(e.toString()));
    }
  }

  Future<void> deleteDepartment(int id) async {
    emit(DeleteDepartmentLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      await dio.delete(
        "${ApiResources.getDepartmentEndPoint}/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      emit(const DeleteDepartmentSuccess("Department deleted successfully"));
      fetchDepartments();
    } catch (e) {
      emit(DeleteDepartmentError(e.toString()));
    }
  }
  Future<void> updateDepartment({
    required int id,
    required String name,
    required String description,
    required int headId,
  }) async {
    emit(UpdateDepartmentLoading());
    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null) {
        emit(const UpdateDepartmentError("Unauthorized"));
        return;
      }

      await dio.put(
        "${ApiResources.getDepartmentEndPoint}/$id",
        data: {
          "name": name,
          "description": description,
          "headId": headId,
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      emit(const UpdateDepartmentSuccess("Department updated successfully"));
      fetchDepartments();
    } catch (e) {
      emit(UpdateDepartmentError(e.toString()));
    }
  }
}

