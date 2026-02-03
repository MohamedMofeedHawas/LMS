import 'package:equatable/equatable.dart';
import '../../get_squadron/model/view.dart'; // تأكد من المسار صح

abstract class GetSquadronsState extends Equatable {
  const GetSquadronsState();

  @override
  List<Object> get props => [];
}

class GetSquadronsInitial extends GetSquadronsState {}

class GetSquadronsLoading extends GetSquadronsState {}

class GetSquadronsLoaded extends GetSquadronsState {
  final List<SquadronModel> squadrons;

  const GetSquadronsLoaded(this.squadrons);

  @override
  List<Object> get props => [squadrons];
}

class GetSquadronsError extends GetSquadronsState {
  final String message;

  const GetSquadronsError(this.message);

  @override
  List<Object> get props => [message];
}