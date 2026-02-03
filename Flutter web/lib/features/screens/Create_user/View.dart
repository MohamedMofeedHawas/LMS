import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lms/features/screens/courses/student/view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../core/helpers/logout_server/logout.dart';
import '../Announcement/view.dart';
import '../Create_department/view.dart';
import '../add_course/Adding_view.dart';
import '../courses/admin/view.dart';
import '../create_years/view.dart';
import '../get_department/model/model.dart';
import '../get_department/state_mangment/cubit.dart';
import '../get_department/state_mangment/states.dart';
import '../get_squadron/model/view.dart';
import '../get_squadron/state_mangment/cubit.dart';
import '../get_squadron/state_mangment/states.dart';
import '../get_users/view.dart';
import '../get_years/model.dart';
import '../get_years/state_managment/cubit.dart';
import '../get_years/state_managment/states.dart';
import '../profiles/admin_profile/view.dart';
import 'State_managment/Create_user_cubit.dart';
import 'State_managment/Create_user_state.dart';

Uint8List? _webImage;
String selectedMenuItem = 'Create Users';
String? hoveredMenuItem;
String selectedGender = "gender";
String selectedRole = "Select Role";
String selectedCity = 'Select City';
bool isLogoutHovered = false;
bool isProfilePictureHovered = false;
bool isNextButtonHovered = false;
bool isActive = true;
bool isCityExpanded = false;
bool isRoleExpanded = false;
late DateTime selectedDateOfBirth;
final List<String> cities = [
  'Cairo',
  'Alexandria',
  'Giza',
  'Shubra El-Kheima',
  'Port Said',
  'Suez',
  'Luxor',
  'Aswan',
  'Qena',
  'Ismailia',
  'Fayoum',
  'Minya',
  'Beni Suef',
  'Assiut',
  'Sohag',
  'Red Sea',
  'North Sinai',
  'South Sinai',
  'Matrouh',
  'New Valley',
  'Damietta',
  'Kafr El Sheikh',
  'Beheira',
  'Monufia',
  'Qalyubia',
  'Sharqia',
  'Daqahlia',
  'Gharbia',
];
final List<Map<String, dynamic>> roles = [
  {
    "name": "Admin",
    "icon": Icons.admin_panel_settings,
    "color": Colors.redAccent,
  },
  {"name": "Instructor", "icon": Icons.school, "color": Colors.orangeAccent},
  {"name": "Student", "icon": Icons.person, "color": Colors.blueAccent},
];

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<CreateUserScreen> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode nationalIdFocus = FocusNode();

  // final FocusNode passwordFocus = FocusNode();
  final FocusNode academicLevelFocus = FocusNode();
  final FocusNode roleFocus = FocusNode();
  final FocusNode dateOfBirthFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode isActiveFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();

  final TextEditingController academicLevelController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  final TextEditingController dobController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController squadronController = TextEditingController();

  String selectedDepartmentName = "Select Department";
  String selectedYearName = "Select Year";
  String selectedSquadronName = "Select Squadron";

  String? selectedDepartmentId;
  String? selectedYearId;
  String? selectedSquadronId;

  List<GetDepartmentModel> availableDepartments = [];
  List<YearModel> availableYears = [];

  bool isDepartmentExpanded = false;
  bool isYearExpanded = false;
  bool isSquadronExpanded = false;

  @override
  void dispose() {
    fullNameController.dispose();
    fullNameFocus.dispose();
    emailController.dispose();
    emailFocus.dispose();
    nationalIdController.dispose();
    nationalIdFocus.dispose();

    academicLevelController.dispose();
    academicLevelFocus.dispose();
    genderController.dispose();
    genderFocus.dispose();

    super.dispose();
  }
  void _clearAllFields() {
    fullNameController.clear();
    emailController.clear();
    nationalIdController.clear();
    genderController.clear();
    dobController.clear();

    setState(() {
      selectedDepartmentName = "Select Department";
      selectedYearName = "Select Year";
      selectedSquadronName = "Select Squadron";
      selectedCity = 'Select City';
      selectedRole = "Select Role";

      selectedDepartmentId = null;
      selectedYearId = null;
      selectedSquadronId = null;

      availableYears = [];

      isDepartmentExpanded = false;
      isYearExpanded = false;
      isSquadronExpanded = false;
      isCityExpanded = false;
      isRoleExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUserCubit(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MYColors.gradientColor_3,
              MYColors.gradientColor_2.withValues(alpha: 0.25),
              MYColors.gradientColor_3,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              _buildSidebar(),
              Expanded(child: _buildProfileContent()),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSidebar() {
    return Container(
      width: 250,
      margin: const EdgeInsetsGeometry.directional(
        start: 40,
        end: 0,
        top: 50,
        bottom: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildMenuItem(
            Icons.person_outline,
            Icons.person,
            'Profile',
            'Profile',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfileScreen(),));
                },
          ),
          _buildMenuItem(
            Icons.book_outlined,
            Icons.book,
            'My Courses',
            'My Courses',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminCourseScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            Icons.notifications_active_outlined,
            Icons.notifications_active_rounded,
            'Announcements',
            'Announcements',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnnouncementScreen(),
                ),
              );

            },
          ),
          _buildMenuItem(
            Icons.person_add_alt_1_outlined,
            Icons.person_add_alt_1,
            'Create Users',
            'Create users',
                () {


            },
          ),
          _buildMenuItem(
            Icons.folder_copy_outlined,
            Icons.folder_copy_rounded,
            'Create Departments',
            'Create Departments',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CreateDepartmentPage(),
                ),
              );

            },
          ),
          _buildMenuItem(
            Icons.calendar_month,
            Icons.calendar_month_outlined,
            'Create Years',
            'Create Years',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CreateYearPage(),
                ),
              );

            },
          ),
          _buildMenuItem(
            Icons.play_circle_outline,
            Icons.play_circle_fill,
            'Create New Course',
            'Create New Course',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CreateNewCoursePage(),
                ),
              );

            },
          ),
          _buildMenuItem(
            Icons.grade_outlined,
            Icons.grade,
            'Grades overview',
            'Grades overview',
                () {},
          ),
          const Spacer(),
          _buildLogoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }




  Widget _buildLogoutButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isLogoutHovered = true),
      onExit: (_) => setState(() => isLogoutHovered = false),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await LogoutServer.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isLogoutHovered
                ? const Color(0xFFEF4444).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isLogoutHovered
                  ? const Color(0xFFEF4444).withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.logout, color: const Color(0xFFEF4444), size: 20),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMenuItem(
      IconData outlinedIcon,
      IconData filledIcon,
      String title,
      String value,
      onTap,
      ) {
    final isSelected = selectedMenuItem == value;
    final isHovered = hoveredMenuItem == value;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredMenuItem = value),
      onExit: (_) => setState(() => hoveredMenuItem = null),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenuItem = value;
          });
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : isHovered
                  ? const Color(0xFF2563EB).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovered && !isSelected
                    ? const Color(0xFF2563EB).withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    key: ValueKey(isSelected),
                    color: isSelected
                        ? Colors.white
                        : isHovered
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF64748B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isHovered
                        ? const Color(0xFF2563EB)
                        : Colors.black87,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          constraints: const BoxConstraints(maxWidth: 1132),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => DepartmentsCubitDrop()..fetchDepartments(),
              ),
              BlocProvider(
                create: (_) => YearsCubitDrop()..fetchYears(),
              ),
              BlocProvider(
                create: (_) => SquadronsCubitDrop()..fetchSquadrons(),
              ),
            ],
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'New User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here are all User personal details that you can add and update anytime',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 32),
                  _buildProfilePicture(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    'Full Name',
                    fullNameController,
                    fullNameFocus,
                    Icons.person,
                    "Mohamed Mofeed",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Email address',
                    emailController,
                    emailFocus,
                    Icons.email,
                    "mohamed@gmail.com",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'National ID',
                    nationalIdController,
                    nationalIdFocus,
                    Icons.badge,
                    "3040105050096",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Gender',
                    genderController,
                    genderFocus,
                    Icons.badge,
                    "Male",
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    'Date of Birth',
                    dobController,
                    dobFocus,
                    "Select Date",
                  ),
                  const SizedBox(height: 16),
                  _buildStringDropdownField(
                    'City',
                    selectedCity,
                    cities,
                    isCityExpanded,
                        (value) {
                      setState(() {
                        selectedCity = value;
                        isCityExpanded = false;
                      });
                    },
                        () => setState(() => isCityExpanded = !isCityExpanded),
                  ),
                  const SizedBox(height: 16),
                  RoleDropdownField(),
                  const SizedBox(height: 16),

                  BlocBuilder<DepartmentsCubitDrop, DepartmentsStateDrop>(
                    builder: (context, departmentState) {
                      final isReadOnly = selectedRole != 'Student';

                      if (departmentState is DepartmentLoadingState) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (departmentState is DepartmentsErrorState) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            "Error: ${departmentState.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (departmentState is DepartmentLoadedState) {
                        if (departmentState.departments.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Text("No departments found"),
                          );
                        }

                        List<GetDepartmentModel> departments =
                        departmentState.departments
                            .whereType<GetDepartmentModel>()
                            .toList();

                        return Column(
                          children: [
                            Opacity(
                              opacity: isReadOnly ? 0.5 : 1.0,
                              child: IgnorePointer(
                                ignoring: isReadOnly,
                                child: _buildDropdownField(
                                  selectedDepartmentName,
                                  departments,
                                  isDepartmentExpanded,
                                      (chosenDep) {
                                    setState(() {
                                      selectedDepartmentId = chosenDep.id.toString();
                                      availableYears = chosenDep.years;
                                      selectedYearName = "Select Year";
                                      selectedYearId = null;
                                      selectedDepartmentName = chosenDep.name;
                                      isDepartmentExpanded = false;
                                    });
                                  },
                                      () => setState(
                                        () => isDepartmentExpanded = !isDepartmentExpanded,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  BlocBuilder<YearsCubitDrop, YearsStateDrop>(
                    builder: (context, yearState) {
                      final isReadOnly = selectedRole != 'Student';

                      if (yearState is YearLoadingState) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (yearState is YearsErrorState) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Error: ${yearState.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (yearState is YearLoadedState) {
                        if (yearState.years.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text("No years found"),
                          );
                        }

                        return Column(
                          children: [
                            Opacity(
                              opacity: isReadOnly ? 0.5 : 1.0,
                              child: IgnorePointer(
                                ignoring: isReadOnly,
                                child: _buildSecondDropdownField(
                                  selectedYearName,
                                  availableYears,
                                  isYearExpanded,
                                      (chosenYear) {
                                    setState(() {
                                      selectedYearName = chosenYear.name;
                                      selectedYearId = chosenYear.id.toString();
                                      isYearExpanded = false;
                                    });
                                  },
                                      () => setState(
                                        () => isYearExpanded = !isYearExpanded,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  BlocBuilder<SquadronsCubitDrop, GetSquadronsState>(
                    builder: (context, squadronState) {
                      final isReadOnly = selectedRole != 'Student';

                      if (squadronState is GetSquadronsLoading) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (squadronState is GetSquadronsError) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Error: ${squadronState.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (squadronState is GetSquadronsLoaded) {
                        if (squadronState.squadrons.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text("No Squadrons found"),
                          );
                        }

                        List<SquadronModel> squadrons = squadronState.squadrons
                            .whereType<SquadronModel>()
                            .toList();

                        return Column(
                          children: [
                            Opacity(
                              opacity: isReadOnly ? 0.5 : 1.0,
                              child: IgnorePointer(
                                ignoring: isReadOnly,
                                child: _buildThirdDropdownField(
                                  selectedSquadronName,
                                  squadrons,
                                  isSquadronExpanded,
                                      (chosenSquadron) {
                                    setState(() {
                                      selectedSquadronName = chosenSquadron.name;
                                      selectedSquadronId = chosenSquadron.id.toString();
                                      isSquadronExpanded = false;
                                    });
                                  },
                                      () => setState(
                                        () => isSquadronExpanded = !isSquadronExpanded,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  BlocListener<CreateUserCubit, CreateState>(
                    listener: (context, state) {
                      if (state is CreateUserSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.message ?? "User Created Successfully",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (state.statusCode != null)
                                        Text(
                                          "Status Code: ${state.statusCode}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            duration: const Duration(seconds: 3),
                            elevation: 6,
                          ),
                        );
                        _clearAllFields();
                      }

                      if (state is CreateUserErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.errorMessage,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (state.statusCode != null)
                                        Text(
                                          "Status Code: ${state.statusCode}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            duration: const Duration(seconds: 3),
                            elevation: 6,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<CreateUserCubit, CreateState>(
                      builder: (context, state) {
                        final isLoading = state is LoadingCreateUserState;

                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () {
                            if (dobController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please select date of birth",
                                  ),
                                ),
                              );
                              return;
                            }

                            SystemSound.play(SystemSoundType.click);
                            context.read<CreateUserCubit>().postCreatedUserData(
                              emailController,
                              fullNameController,
                              nationalIdController,
                              genderController,
                              selectedDateOfBirth,
                              selectedCity,
                              selectedRole,
                              context,
                              profileImageBytes: kIsWeb
                                  ? _webImage
                                  : _selectedImage?.readAsBytesSync(),
                              departmentId: selectedRole == 'Student'
                                  ? selectedDepartmentId
                                  : null,
                              yearId: selectedRole == 'Student'
                                  ? selectedYearId
                                  : null,
                              squadronId: selectedRole == 'Student'
                                  ? selectedSquadronId
                                  : null,
                            );
                          },
                          child: Center(
                            child: Container(
                              width: 470,
                              height: 45,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF1849A9), Color(0xFF53B1FD)],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: isLoading
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Creating User...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "inter",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                                    : const Text(
                                  "Create User",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "inter",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSecondDropdownField(
      String displayValue,
      List<YearModel> years,
      bool isExpanded,
      Function(YearModel) onSelected,
      Function() onToggle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Year Name",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: isExpanded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: years.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  "No years already created for this department",
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                return InkWell(
                  onTap: () => onSelected(year),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            year.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (displayValue == year.name)
                          const Icon(
                            Icons.check,
                            color: Color(0xFF2563EB),
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField(
    String displayValue,
    List<GetDepartmentModel> departments,
    bool isExpanded,
    Function(GetDepartmentModel) onSelected,
    Function() onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Department Name",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: isExpanded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final department = departments[index];
                return InkWell(
                  onTap: () => onSelected(department),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${department.name} (${department.headName})",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (displayValue == department.name)
                          const Icon(
                            Icons.check,
                            color: Color(0xFF2563EB),
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildThirdDropdownField(
      String displayValue,
      List<SquadronModel> squadrons,
      bool isExpanded,
      Function(SquadronModel) onSelected,
      Function() onToggle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Squadron Name",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: isExpanded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: squadrons.length,
              itemBuilder: (context, index) {
                final squadron = squadrons[index];
                return InkWell(
                  onTap: () => onSelected(squadron),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${squadron.name} (${squadron.studentCount})",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (displayValue == squadron.name)
                          const Icon(
                            Icons.check,
                            color: Color(0xFF2563EB),
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }




  Widget _buildProfilePicture() {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isProfilePictureHovered = true),
        onExit: (_) => setState(() => isProfilePictureHovered = false),
        child: GestureDetector(
          onTap: _pickImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..scale(isProfilePictureHovered ? 1.05 : 1.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isProfilePictureHovered
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF2563EB).withOpacity(0.3),
                      width: isProfilePictureHovered ? 4 : 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF2563EB,
                        ).withOpacity(isProfilePictureHovered ? 0.3 : 0.1),
                        blurRadius: isProfilePictureHovered ? 20 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: kIsWeb
                        ? (_webImage != null
                              ? MemoryImage(_webImage!)
                              : const AssetImage(
                                      'assets/images/chatbot man.png',
                                    )
                                    as ImageProvider)
                        : (_selectedImage != null
                              ? FileImage(_selectedImage!)
                              : const AssetImage(
                                  'assets/images/chatbot man.png',
                                )),
                  ),
                ),

                if (isProfilePictureHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Change Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.identity()
                      ..rotateZ(isProfilePictureHovered ? 0.2 : 0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.5),
                            blurRadius: isProfilePictureHovered ? 12 : 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isProfilePictureHovered ? Icons.edit : Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    _pickImageFromSource(ImageSource.gallery);
    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => Container(
    //     decoration: const BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //     ),
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Container(
    //           width: 40,
    //           height: 4,
    //           decoration: BoxDecoration(
    //             color: Colors.grey[300],
    //             borderRadius: BorderRadius.circular(2),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         const Text(
    //           'Choose Profile Picture',
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.w700,
    //             color: Color(0xFF1E293B),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         _buildImageSourceOption(
    //           icon: Icons.photo_library,
    //           title: 'Choose from Gallery',
    //           subtitle: 'Select an existing photo',
    //           onTap: () {
    //             Navigator.pop(context);
    //             _pickImageFromSource(ImageSource.gallery);
    //           },
    //         ),
    //         const SizedBox(height: 12),
    //         _buildImageSourceOption(
    //           icon: Icons.camera_alt,
    //           title: 'Take admin_profile Photo',
    //           subtitle: 'Use your camera',
    //           onTap: () {
    //             Navigator.pop(context);
    //             _pickImageFromSource(ImageSource.camera);
    //           },
    //         ),
    //         if (_selectedImage != null) ...[
    //           const SizedBox(height: 12),
    //           _buildImageSourceOption(
    //             icon: Icons.delete_outline,
    //             title: 'Remove Photo',
    //             subtitle: 'Use default avatar',
    //             color: const Color(0xFFEF4444),
    //             onTap: () {
    //               Navigator.pop(context);
    //               setState(() {
    //                 _selectedImage = null;
    //               });
    //               _showSuccessSnackbar('Profile picture removed');
    //             },
    //           ),
    //         ],
    //         const SizedBox(height: 20),
    //       ],
    //     ),
    //   ),
    // );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() => _webImage = bytes);
        } else {
          setState(() => _selectedImage = File(pickedFile.path));
        }
        _showSuccessSnackbar('Profile picture updated successfully!');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image. Please try again.');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    IconData icon,
    String hint,
  ) {
    return StatefulBuilder(
      builder: (context, setFieldState) {
        bool isHovered = false;

        return AnimatedBuilder(
          animation: focusNode,
          builder: (context, child) {
            final isFocused = focusNode.hasFocus;
            final bool isActive = isFocused || isHovered;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isActive ? 15 : 14,
                    fontWeight: FontWeight.w600,
                    color: isFocused
                        ? const Color(0xFF2563EB)
                        : isHovered
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF2563EB),
                  ),
                  child: Text(label),
                ),
                const SizedBox(height: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.text,
                  onEnter: (_) => setFieldState(() => isHovered = true),
                  onExit: (_) => setFieldState(() => isHovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..translate(0.0, isActive ? -2.0 : 0.0),
                    decoration: BoxDecoration(
                      color: isFocused
                          ? Colors.white
                          : isHovered
                          ? const Color(0xFFFEFEFE)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isFocused
                            ? const Color(0xFF2563EB)
                            : isHovered
                            ? const Color(0xFF93C5FD)
                            : const Color(0xFFE2E8F0),
                        width: isFocused
                            ? 2
                            : isHovered
                            ? 1.5
                            : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                            ]
                          : isHovered
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF2563EB,
                                ).withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF1E293B),
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..scale(isActive ? 1.1 : 1.0),
                          child: Icon(
                            icon,
                            color: isFocused
                                ? const Color(0xFF2563EB)
                                : isHovered
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                        suffixIcon: isActive
                            ? AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isActive ? 1.0 : 0.0,
                                child: Icon(
                                  isFocused ? Icons.edit : Icons.touch_app,
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withOpacity(0.4),
                                  size: 18,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Widget _buildDateField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
  ) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final isFocused = focusNode.hasFocus;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isFocused ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isFocused
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isFocused ? 2 : 1,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1975, 9, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF2563EB),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedDateOfBirth = picked;
                    controller.text =
                        '${picked.day}/${picked.month}/${picked.year}';
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStringDropdownField(
    String label,
    String value,
    List<String> options,
    bool isExpanded,
    Function(String) onSelected,
    Function() onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.public,
                        color: isExpanded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isExpanded
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option == value;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isSelected
                          ? const Color(0xFF2563EB).withOpacity(0.1)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF1E293B),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // Widget _buildCreateButton() {
  //   return MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     onEnter: (_) => setState(() => isNextButtonHovered = true),
  //     onExit: (_) => setState(() => isNextButtonHovered = false),
  //     child: GestureDetector(
  //       onTap: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: const Row(
  //               children: [
  //                 Icon(Icons.check_circle, color: Colors.white),
  //                 SizedBox(width: 12),
  //                 Text('Profile updated successfully!'),
  //               ],
  //             ),
  //             backgroundColor: const Color(0xFF10B981),
  //             behavior: SnackBarBehavior.floating,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //         );
  //       },
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 200),
  //         width: double.infinity,
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: isNextButtonHovered
  //                 ? [const Color(0xFF1D4ED8), const Color(0xFF2563EB)]
  //                 : [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
  //           ),
  //           borderRadius: BorderRadius.circular(8),
  //           boxShadow: isNextButtonHovered
  //               ? [
  //                   BoxShadow(
  //                     color: const Color(0xFF2563EB).withOpacity(0.4),
  //                     blurRadius: 16,
  //                     offset: const Offset(0, 6),
  //                     spreadRadius: 2,
  //                   ),
  //                 ]
  //               : [
  //                   BoxShadow(
  //                     color: const Color(0xFF2563EB).withOpacity(0.2),
  //                     blurRadius: 8,
  //                     offset: const Offset(0, 2),
  //                   ),
  //                 ],
  //         ),
  //         child: Center(
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 'Create',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               AnimatedContainer(
  //                 duration: const Duration(milliseconds: 200),
  //                 transform: Matrix4.translationValues(
  //                   isNextButtonHovered ? 4 : 0,
  //                   0,
  //                   0,
  //                 ),
  //                 child: const Icon(
  //                   Icons.arrow_forward,
  //                   color: Colors.white,
  //                   size: 18,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class DateRangeSelector extends StatelessWidget {
  final List<String> years = [for (int y = 1980; y <= 2030; y++) y.toString()];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Start / End Date",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _buildDropdown("2020")),
            const SizedBox(width: 16),
            Expanded(child: _buildDropdown("2025")),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String initialValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xF3F7FBFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        decoration: const InputDecoration(border: InputBorder.none),
        items: years
            .map(
              (y) => DropdownMenuItem(
                value: y,
                child: Text(y, style: const TextStyle(fontSize: 15)),
              ),
            )
            .toList(),
        onChanged: (value) {},
      ),
    );
  }
}

class ToggleButtonActiveOrDeactive extends StatefulWidget {
  const ToggleButtonActiveOrDeactive({super.key});

  @override
  State<ToggleButtonActiveOrDeactive> createState() => _ActiveSwitchRowState();
}

class _ActiveSwitchRowState extends State<ToggleButtonActiveOrDeactive> {
  bool isActive = true;
  String status = "Active";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.green : Colors.grey.shade700,
          ),
        ),

        Switch(
          value: isActive,
          onChanged: (value) {
            setState(() {
              isActive = value;

              status = isActive ? "Active" : "Inactive";

              if (isActive) {
                print("Value stored: Active");
              } else {
                print("Value deleted / set to Inactive");
              }
            });
          },
          activeColor: Colors.white,
          activeTrackColor: Colors.green,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade400,
        ),
      ],
    );
  }
}

class RoleDropdownField extends StatefulWidget {
  const RoleDropdownField({super.key});

  @override
  State<RoleDropdownField> createState() => _RoleDropdownFieldState();
}

class _RoleDropdownFieldState extends State<RoleDropdownField> {
  @override
  Widget build(BuildContext context) {
    return _buildDropdownField(
      'Role',
      selectedRole,
      roles,
      isRoleExpanded,
      (value) {
        setState(() {
          selectedRole = value["name"];
          isRoleExpanded = false;

          debugPrint("Selected Role: $selectedRole");
        });
      },
      () {
        setState(() {
          isRoleExpanded = !isRoleExpanded;
        });
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<Map<String, dynamic>> options,
    bool isExpanded,
    Function(Map<String, dynamic>) onSelected,
    Function() onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        options.firstWhere(
                          (role) => role["name"] == value,
                          orElse: () => {
                            "icon": Icons.person,
                            "color": Colors.grey,
                          },
                        )["icon"],
                        color: isExpanded
                            ? const Color(0xFF2563EB)
                            : options.firstWhere(
                                (role) => role["name"] == value,
                                orElse: () => {
                                  "icon": Icons.person,
                                  "color": Colors.grey,
                                },
                              )["color"],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isExpanded
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option["name"] == value;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isSelected
                          ? option["color"].withOpacity(0.1)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: option["color"],
                                child: Icon(
                                  option["icon"],
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                option["name"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? option["color"]
                                      : const Color(0xFF1E293B),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Icon(Icons.check, color: option["color"], size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
