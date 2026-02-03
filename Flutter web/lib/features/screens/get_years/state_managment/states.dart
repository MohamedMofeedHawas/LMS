
import 'package:lms/features/screens/get_department/model/model.dart';

import '../model.dart';

abstract class YearsStateDrop {}

class YearInitialState extends YearsStateDrop {}

class YearLoadingState extends YearsStateDrop {}

class YearLoadedState extends YearsStateDrop {
  final List<GetYearModel> years;
  YearLoadedState(this.years);

}

class YearsErrorState extends YearsStateDrop {
  final String message;
  YearsErrorState(this.message);
}
