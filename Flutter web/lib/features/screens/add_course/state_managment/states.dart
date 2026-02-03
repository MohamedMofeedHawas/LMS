import 'package:equatable/equatable.dart';

abstract class CreateCourseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCourseInitial extends CreateCourseState {}

class CreateCourseLoading extends CreateCourseState {}

class CreateCourseSuccess extends CreateCourseState {
  final String message;
  CreateCourseSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CreateCourseError extends CreateCourseState {
  final String message;
  CreateCourseError(this.message);
  @override
  List<Object?> get props => [message];
}