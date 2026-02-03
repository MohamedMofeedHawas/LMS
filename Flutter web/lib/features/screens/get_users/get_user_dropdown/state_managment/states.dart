import '../model_dropdown/view.dart';

abstract class UsersStateDrop {}

class UsersInitialState extends UsersStateDrop {}

class UsersLoadingState extends UsersStateDrop {}

class UsersLoadedState extends UsersStateDrop {
  final List<UserLiteModel> users;
  UsersLoadedState(this.users);
}

class UsersErrorState extends UsersStateDrop {
  final String message;
  UsersErrorState(this.message);
}
