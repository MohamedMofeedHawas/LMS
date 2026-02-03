import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/cons/api_helper_resources/api_resources.dart';
import 'package:lms/features/draft/test_models.dart';
import 'package:lms/features/draft/test_states.dart';
import 'package:lms/features/screens/get_years/get_All_years/state_mangement/states.dart';

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../all_model/model.dart';


class AllYearsCubit extends Cubit<AllYearsState> {
  AllYearsCubit() : super(YearsInitial());

  final Dio dio = Dio(
    BaseOptions(baseUrl: ApiResources.apiUrl),
  );

  Future<void> fetchYearss() async {
    emit(YearsLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      final response = await dio.get(
        ApiResources.getYearEndPoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final years = (response.data as List)
          .map((e) => GetAllYearModel.fromJson(e))
          .toList();

      emit(YearsLoaded(years));
    } catch (e) {
      emit(YearsError(e.toString()));
    }
  }

  Future<void> deleteYear(int id) async {
    emit(YearsLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      await dio.delete(
        "${ApiResources.getYearEndPoint}/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      emit(const DeleteYearSuccess("Department deleted successfully"));
      fetchYearss();
    } catch (e) {
      emit(DeleteYearError(e.toString()));
    }
  }
  Future<void> updateYears({
    required int id,
    required String name,
    required String description,
    required int headId,
  }) async {
    emit(UpdateYearLoading());
    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null) {
        emit(const UpdateYearError("Unauthorized"));
        return;
      }

      await dio.put(
        "${ApiResources.getYearEndPoint}/$id",
        data: {
          "name": name,
          "description": description,
          "headId": headId,
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      emit(const UpdateYearSuccess("Department updated successfully"));
      fetchYearss();
    } catch (e) {
      emit(UpdateYearError(e.toString()));
    }
  }
}

