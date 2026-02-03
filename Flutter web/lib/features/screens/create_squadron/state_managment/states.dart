import 'package:equatable/equatable.dart';

abstract class SquadronState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SquadronInitial extends SquadronState {}

class SquadronLoading extends SquadronState {}

class SquadronSuccess extends SquadronState {
  final String message;
  SquadronSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class SquadronError extends SquadronState {
  final String message;
  SquadronError(this.message);
  @override
  List<Object?> get props => [message];
}