import 'package:equatable/equatable.dart';
import 'package:lms/features/draft/test_models.dart';

import '../get_user_model/view.dart';


abstract class GetUsersState extends Equatable {
  const GetUsersState();

  @override
  List<Object?> get props => [];
}

class GetUsersInitial extends GetUsersState {}

class GetUsersLoading extends GetUsersState {}

class GetUsersLoaded extends GetUsersState {
  final UsersResponseModel usersResponse;
  final String searchQuery;
  final int currentPage;
  final int filterStatus;
  final String sortBy;
  final String order;

  const GetUsersLoaded({
    required this.usersResponse,
    this.searchQuery = '',
    this.currentPage = 1,
    this.filterStatus = 0,
    this.sortBy = 'createdAt',
    this.order = 'desc',
  });

  GetUsersLoaded copyWith({
    UsersResponseModel? usersResponse,
    String? searchQuery,
    int? currentPage,
    int? filterStatus,
    String? sortBy,
    String? order,
  }) {
    return GetUsersLoaded(
      usersResponse: usersResponse ?? this.usersResponse,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    usersResponse,
    searchQuery,
    currentPage,
    filterStatus,
    sortBy,
    order,
  ];
}

class GetUsersUnauthorized extends GetUsersState {}

class GetUsersError extends GetUsersState {
  final String message;
  const GetUsersError(this.message);

  @override
  List<Object?> get props => [message];
}
class DeleteUserLoading extends GetUsersState {}

class DeleteUserSuccess extends GetUsersState {
  final String message;

  const DeleteUserSuccess(this.message);
}

class DeleteUserError extends GetUsersState {
  final String message;

  const DeleteUserError(this.message);
}
class GetUsersLoadingMore extends GetUsersState {}
class DeactivateUserLoading extends GetUsersState {}

class DeactivateUserSuccess extends GetUsersState {
  final String message;
  const DeactivateUserSuccess(this.message);
}

class DeactivateUserError extends GetUsersState {
  final String message;
  const DeactivateUserError(this.message);
}

class ActivateUserLoading extends GetUsersState {}

class ActivateUserSuccess extends GetUsersState {
  final String message;
  const ActivateUserSuccess(this.message);
}

class ActivateUserError extends GetUsersState {
  final String message;
  const ActivateUserError(this.message);
}

// class UpdateUsersLoading extends GetUsersState {}
//
// class UpdateUsersSuccess extends GetUsersState {
//   final String message;
//   const UpdateUsersSuccess(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
//
// class UpdateUsersError extends GetUsersState {
//   final String message;
//   const UpdateUsersError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
class UpdateUsersLoading extends GetUsersState {}

class UpdateUsersSuccess extends GetUsersState {
  final String message;
  final int? statusCode;

  const UpdateUsersSuccess(this.message, {this.statusCode});
}

class UpdateUsersError extends GetUsersState {
  final String errorMessage;
  final int? statusCode;

  const UpdateUsersError(this.errorMessage, {this.statusCode});
}
// ====================== Get User By ID ======================

class GetUserByIdLoading extends GetUsersState {
  const GetUserByIdLoading();

  @override
  List<Object?> get props => [];
}

class GetUserByIdSuccess extends GetUsersState {
  final GetUserModel user;

  const GetUserByIdSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class GetUserByIdError extends GetUsersState {
  final String message;

  const GetUserByIdError(this.message);

  @override
  List<Object?> get props => [message];
}
