import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/cons/api_helper_resources/api_resources.dart';
import 'package:lms/core/helpers/cach_helper/shared_pref_helper.dart';
import 'package:lms/features/draft/test_models.dart';
import 'package:lms/features/draft/test_states.dart';

import '../get_user_model/view.dart';
import 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersState> {
  final Dio dio;

  GetUsersCubit({required this.dio}) : super(GetUsersInitial());

  Future<void> fetchUsers({
    int page = 1,
    String searchQuery = '',
    int filterStatus = 0,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) async {
    if (page == 1) emit(GetUsersLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(const GetUsersError('Authentication required'));
        return;
      }

      final response = await dio.get(
        "${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}",
        queryParameters: {
          'pageNumber': page,
          'pageSize': 10,
          'search': searchQuery,
          'filterStatus': filterStatus,
          'sortBy': sortBy,
          'order': order,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('STATUS: ${response.statusCode}');
      // print('DATA: ${response.data}');

      if (response.statusCode != 200 || response.data is! Map<String, dynamic>) {
        emit(GetUsersError('Invalid response from server'));
        return;
      }

      final usersResponse = UsersResponseModel.fromJson(response.data);

      if (state is GetUsersLoaded && page > 1) {
        final oldState = state as GetUsersLoaded;

        final mergedUsers = [
          ...oldState.usersResponse.users,
          ...usersResponse.users.where(
                (newUser) => !oldState.usersResponse.users
                .any((oldUser) => oldUser.id == newUser.id),
          ),
        ];

        final mergedResponse = oldState.usersResponse.copyWith(
          users: mergedUsers,
          pageNumber: usersResponse.pageNumber,
          pageSize: usersResponse.pageSize,
          totalPages: usersResponse.totalPages,
          hasNextPage: usersResponse.hasNextPage,
          hasPreviousPage: usersResponse.hasPreviousPage,
          totalCount: usersResponse.totalCount,
        );

        emit(GetUsersLoaded(
          usersResponse: mergedResponse,
          searchQuery: searchQuery,
          currentPage: page,
          filterStatus: filterStatus,
          sortBy: sortBy,
          order: order,
        ));
      } else {
        emit(GetUsersLoaded(
          usersResponse: usersResponse,
          searchQuery: searchQuery,
          currentPage: page,
          filterStatus: filterStatus,
          sortBy: sortBy,
          order: order,
        ));
      }
    } on DioException catch (e) {
      print('❌ DIO ERROR: ${e.response?.data}');
      emit(GetUsersError(
        e.response?.data.toString() ?? e.message ?? 'Network error',
      ));
    } catch (e, stack) {
      print('❌ UNEXPECTED ERROR');
      print(e);
      print(stack);
      emit(const GetUsersError('Unexpected error occurred'));
    }
  }
  Future<void> deactivateUser(int userId) async {
    emit(DeactivateUserLoading());
    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(const GetUsersError("Unauthorized: Please login again."));
        return;
      }
      final response = await dio.delete(
        '${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(DeactivateUserSuccess('User deactivated successfully'));
        await fetchUsers();
      }
    } on DioException catch (e) {
      emit(DeactivateUserError(e.response?.data['message'] ?? 'Failed to deactivate user'));
    }
  }

  // Future<void> activateUser(int userId) async {
  //   emit(ActivateUserLoading());
  //   try {
  //     final token = await TokenStorageHelper.getTokenSecure();
  //
  //     if (token == null || token.isEmpty) {
  //       emit(const GetUsersError("Unauthorized: Please login again."));
  //       return;
  //     }
  //     final response = await dio.patch(
  //       '${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}/$userId',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       emit(ActivateUserSuccess('User activated successfully'));
  //       await fetchUsers();
  //     }
  //   } on DioException catch (e) {
  //     emit(ActivateUserError(e.response?.data['message'] ?? 'Failed to activate user'));
  //   }
  // }

  Future<void> filterUsers({
    String searchQuery = '',
    int filterStatus = 0,
    String sortBy = 'createdAt',
  }) async {
    await fetchUsers(
      page: 1,
      searchQuery: searchQuery,
      filterStatus: filterStatus,
      sortBy: sortBy,
      order: 'desc',
    );
  }

  Future<void> sortUsers({
    required String sortBy,
    String order = 'desc',
  }) async {
    if (state is! GetUsersLoaded) return;
    final currentState = state as GetUsersLoaded;
    await fetchUsers(
      page: 3000,
      searchQuery: currentState.searchQuery,
      filterStatus: currentState.filterStatus,
      sortBy: sortBy,
      order: order,
    );
  }

  Future<void> goToPage(int pageNumber) async {
    if (state is! GetUsersLoaded) return;
    final currentState = state as GetUsersLoaded;
    if (pageNumber > currentState.usersResponse.totalPages) return;
    await fetchUsers(
      page: pageNumber,
      searchQuery: currentState.searchQuery,
      filterStatus: currentState.filterStatus,
      sortBy: currentState.sortBy,
      order: currentState.order,
    );
  }
  Future<void> deleteUser(int userId) async {
    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(const GetUsersError("Unauthorized: Please login again."));
        return;
      }

      final currentState = state;

      emit(DeleteUserLoading());

      final response = await dio.delete(
        '${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}/$userId',
        queryParameters: {
          'hardDelete': true,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(DeleteUserSuccess('User deleted successfully'));

        if (currentState is GetUsersLoaded) {
          await fetchUsers(
            page: currentState.currentPage,
            searchQuery: currentState.searchQuery,
            filterStatus: currentState.filterStatus,
            sortBy: currentState.sortBy,
            order: currentState.order,
          );
        }
      } else {
        emit(DeleteUserError('Failed to delete user'));

        if (currentState is GetUsersLoaded) {
          emit(currentState);
        }
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ??
          e.response?.data.toString() ??
          e.message ??
          'Connection error';
      emit(DeleteUserError(errorMsg));

      if (state is GetUsersLoaded) {
        final currentState = state as GetUsersLoaded;
        await fetchUsers(
          page: currentState.currentPage,
          searchQuery: currentState.searchQuery,
          filterStatus: currentState.filterStatus,
          sortBy: currentState.sortBy,
          order: currentState.order,
        );
      }
    } catch (e) {
      emit(DeleteUserError('Unexpected error: ${e.toString()}'));
    }
  }
  Future<void> getUserById(int userId) async {
    emit(GetUserByIdLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();

      if (token == null || token.isEmpty) {
        emit(const GetUserByIdError("Unauthorized: Please login again."));
        return;
      }

      final dio = Dio();

      final response = await dio.get(
        "${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}/$userId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final user = GetUserModel.fromJson(response.data);
        emit(GetUserByIdSuccess(user));
      } else {
        emit(
          GetUserByIdError(
            "Failed to load user. Status: ${response.statusCode}",
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GetUserByIdError(
          e.response?.data?['message'] ??
              e.message ??
              "Connection error",
        ),
      );
    } catch (e) {
      emit(GetUserByIdError("Unexpected error: $e"));
    }
  }



  Future<void> updateUser({
    required int userId,
    required Map<String, dynamic> userData,
  }) async {
    emit(UpdateUsersLoading());

    try {
      final token = await TokenStorageHelper.getTokenSecure();
      if (token == null || token.isEmpty) {
        emit(const UpdateUsersError("Unauthorized: Please login again."));
        return;
      }

      final response = await dio.put(
        "${ApiResources.apiUrl}${ApiResources.getUsersEndPoint}/$userId",
        data: userData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(UpdateUsersSuccess(
          "User updated successfully",
          statusCode: response.statusCode,
        ));

        await fetchUsers();
      } else {
        emit(UpdateUsersError(
          "Failed to update user",
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      emit(UpdateUsersError(
        e.response?.data?['message'] ??
            e.message ??
            "Error while updating user",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      emit(UpdateUsersError("Unexpected error: $e"));
    }
  }


}
