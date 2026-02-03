






import '../model/view.dart';

abstract class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileUser profile;
  AdminProfileLoaded({required this.profile});
}

class AdminProfileError extends AdminProfileState {
  final String message;
  AdminProfileError({required this.message});
}
