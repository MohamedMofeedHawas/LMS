






import '../model/view.dart';

abstract class TeacherProfileState {}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileLoaded extends TeacherProfileState {
  final TeacherProfileUser profile;
  TeacherProfileLoaded({required this.profile});
}

class TeacherProfileError extends TeacherProfileState {
  final String message;
  TeacherProfileError({required this.message});
}
