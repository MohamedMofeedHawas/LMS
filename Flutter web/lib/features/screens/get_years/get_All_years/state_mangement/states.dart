import 'package:equatable/equatable.dart';
import 'package:lms/features/draft/test_models.dart';

import '../all_model/model.dart';


abstract class AllYearsState extends Equatable {
  const AllYearsState();

  @override
  List<Object?> get props => [];
}

class YearsInitial extends AllYearsState {}

class YearsLoading extends AllYearsState {}

class YearsLoaded extends AllYearsState {
  final List<GetAllYearModel> years;

  const YearsLoaded(this.years);

  @override
  List<Object?> get props => [years];
}

class YearsError extends AllYearsState {
  final String message;
  const YearsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteYearLoading extends AllYearsState {}

class DeleteYearSuccess extends AllYearsState {
  final String message;
  const DeleteYearSuccess(this.message);
}

class DeleteYearError extends AllYearsState {
  final String message;
  const DeleteYearError(this.message);
}

class UpdateYearLoading extends AllYearsState {}

class UpdateYearSuccess extends AllYearsState {
  final String message;
  const UpdateYearSuccess(this.message);
}

class UpdateYearError extends AllYearsState {
  final String message;
  const UpdateYearError(this.message);
}
