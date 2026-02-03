import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/get_users/get_user_dropdown/state_managment/states.dart' hide UsersState;

import '../../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../model_dropdown/view.dart';

class UsersCubitDrop extends Cubit<UsersStateDrop> {
  UsersCubitDrop() : super(UsersInitialState());

  Future<void> fetchAdminsAndInstructors() async {
    emit(UsersLoadingState());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(UsersErrorState("Unauthorized"));
        return;
      }

      final response = await Dio().get(
        "https://skylearn.runasp.net/api/Users",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final List usersJson = response.data['users'];

      final users = usersJson
          .map((e) => UserLiteModel.fromJson(e))
          .where((u) =>
      u.role.toLowerCase() == "admin" ||
          u.role.toLowerCase() == "instructor")
          .toList();

      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UsersErrorState("Failed to load users"));
    }
  }
}
