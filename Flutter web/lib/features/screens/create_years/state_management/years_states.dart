import 'package:equatable/equatable.dart';

abstract class YearState extends Equatable {
  @override
  List<Object?> get props => [];
}

class YearInitial extends YearState {}

class YearLoading extends YearState {}

class YearSuccess extends YearState {
  final String message;
  YearSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class YearError extends YearState {
  final String message;
  YearError(this.message);
  @override
  List<Object?> get props => [message];
}