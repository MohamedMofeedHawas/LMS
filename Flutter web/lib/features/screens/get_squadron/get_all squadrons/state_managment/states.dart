import 'package:equatable/equatable.dart';
import '../../model/view.dart';

abstract class AllSquadronState extends Equatable {
  const AllSquadronState();

  @override
  List<Object?> get props => [];
}

class AllSquadronInitial extends AllSquadronState {}

class AllSquadronLoading extends AllSquadronState {}

class AllSquadronLoaded extends AllSquadronState {
  final List<SquadronModel> squadrons;

  const AllSquadronLoaded(this.squadrons);

  @override
  List<Object?> get props => [squadrons];
}

class AllSquadronError extends AllSquadronState {
  final String message;

  const AllSquadronError(this.message);

  @override
  List<Object?> get props => [message];
}
class GetSquadronByIdLoading extends AllSquadronState {}

class GetSquadronByIdLoaded extends AllSquadronState {
  final SquadronModel squadron;

  const GetSquadronByIdLoaded(this.squadron);
}

class UpdateSquadronLoading extends AllSquadronState {}

class UpdateSquadronSuccess extends AllSquadronState {
  final String message;

  const UpdateSquadronSuccess(this.message);
}

