import 'package:equatable/equatable.dart';

abstract class DepartmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentSuccess extends DepartmentState {
  final String message;
  DepartmentSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DepartmentError extends DepartmentState {
  final String message;
  DepartmentError(this.message);
  @override
  List<Object?> get props => [message];
}