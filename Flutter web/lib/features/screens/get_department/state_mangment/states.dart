
import 'package:lms/features/screens/get_department/model/model.dart';

abstract class DepartmentsStateDrop {}

class DepartmentInitialState extends DepartmentsStateDrop {}

class DepartmentLoadingState extends DepartmentsStateDrop {}

class DepartmentLoadedState extends DepartmentsStateDrop {
  final List<GetDepartmentModel> departments;
  DepartmentLoadedState(this.departments);
}

class DepartmentsErrorState extends DepartmentsStateDrop {
  final String message;
  DepartmentsErrorState(this.message);
}
