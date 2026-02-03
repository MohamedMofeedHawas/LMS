import 'package:equatable/equatable.dart';
import 'package:lms/features/draft/test_models.dart';

import '../all_model/model.dart';

abstract class DepartmentsState extends Equatable {
  const DepartmentsState();

  @override
  List<Object?> get props => [];
}

class DepartmentsInitial extends DepartmentsState {}

class DepartmentsLoading extends DepartmentsState {}

class DepartmentsLoaded extends DepartmentsState {
  final List<GetAllDepartmentModel> departments;

  const DepartmentsLoaded(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentsError extends DepartmentsState {
  final String message;
  const DepartmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteDepartmentLoading extends DepartmentsState {}

class DeleteDepartmentSuccess extends DepartmentsState {
  final String message;
  const DeleteDepartmentSuccess(this.message);
}

class DeleteDepartmentError extends DepartmentsState {
  final String message;
  const DeleteDepartmentError(this.message);
}

class UpdateDepartmentLoading extends DepartmentsState {}

class UpdateDepartmentSuccess extends DepartmentsState {
  final String message;
  const UpdateDepartmentSuccess(this.message);
}

class UpdateDepartmentError extends DepartmentsState {
  final String message;
  const UpdateDepartmentError(this.message);
}
