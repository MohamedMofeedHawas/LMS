import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:lms/features/screens/create_years/state_management/years_cubit.dart';
import 'package:lms/features/screens/create_years/state_management/years_states.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/cons/api_helper_resources/api_resources.dart';
import '../../../core/helpers/logout_server/logout.dart';
import '../Announcement/view.dart';
import '../Create_user/View.dart';
import '../courses/admin/view.dart';
import '../get_department/model/model.dart';
import '../get_department/state_mangment/cubit.dart';
import '../get_department/state_mangment/states.dart';

import '../profiles/admin_profile/view.dart';


class CreateYearPage extends StatelessWidget {
  const CreateYearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YearCubit(),
      child: const CreateYearScreen(),
    );
  }
}

class CreateYearScreen extends StatefulWidget {
  const CreateYearScreen({super.key});

  @override
  State<CreateYearScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateYearScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final departmentNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isDepartmentExpanded = false;

  String selectedMenuItem = 'Create Years';
  String? hoveredMenuItem;
  bool isLogoutHovered = false;
  String selectedDepartmentName = "Select Department";
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final dobStartController = TextEditingController();
  final dobEndController = TextEditingController();
  final dobStartFocus = FocusNode();
  final dobEndFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    departmentNameController.dispose();
    dobStartController.dispose();
    dobEndController.dispose();
    dobStartFocus.dispose();
    dobEndFocus.dispose();

    super.dispose();
  }





  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      hintText: label,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MYColors.gradientColor_3,
              MYColors.gradientColor_2.withOpacity(0.25),
              MYColors.gradientColor_3,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            _buildSidebar(),
            BlocConsumer<YearCubit, YearState>(
              listener: (context, state) {
                if (state is YearSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                  );
                  _clearForm();
                }
                if (state is YearError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: _buildFormContainer(state),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    departmentNameController.clear();

    setState(() =>  selectedDepartmentName = "Select Department");
  }

  Widget _buildField(
      String label,
      TextEditingController nameController, {
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),

        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: (v) => v!.isEmpty ? "Field Required" : null,

          controller: nameController,
          maxLines: maxLines,
          decoration: _inputStyle(label),
        ),
      ],
    );
  }


  Widget _buildActionButtons(YearState state) {
    bool isLoading = state is YearLoading;
    return Row(
      children: [

        Expanded(
          flex: 2,
          child: InkWell(
            onTap: isLoading ? null : () {
              if (_formKey.currentState!.validate()) {
                if (selectedStartDate == null || selectedEndDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select both start and end dates"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (selectedDepartmentName == "Select Department" || selectedDepartmentName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a department name"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }


                context.read<YearCubit>().createYear(
                  nameController,
                  descriptionController,
                  selectedDepartmentName,
                  selectedStartDate!,
                  selectedEndDate!,
                );
              }
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1849A9),
                    Color(0xFF53B1FD),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isLoading
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Creating Year...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                    : const Text(
                  "Create Year",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildFormContainer(YearState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1124),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Year",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildField(
                        "Year Name",
                        nameController,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: BlocProvider(
                        create: (_) => DepartmentsCubitDrop()..fetchDepartments(),
                        child: BlocBuilder<DepartmentsCubitDrop, DepartmentsStateDrop>(
                          builder: (context, departmentState) {
                            if (departmentState is DepartmentLoadingState) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            if (departmentState is DepartmentsErrorState) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text("Error: ${departmentState.message}",
                                    style: const TextStyle(color: Colors.red)),
                              );
                            }

                            if (departmentState is DepartmentLoadedState) {
                              if (departmentState.departments.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text("No departments found"),
                                );
                              }

                              List<GetDepartmentModel> departments = departmentState.departments.whereType<GetDepartmentModel>().toList();

                              return _buildDropdownField(
                                selectedDepartmentName,
                                departments,
                                isDepartmentExpanded,
                                    (chosenUser) {
                                  setState(() {
                                    selectedDepartmentName = chosenUser.name;
                                    isDepartmentExpanded = false;
                                  });
                                },
                                    () => setState(() => isDepartmentExpanded = !isDepartmentExpanded),
                              );
                            }

                            return const SizedBox(height: 50);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

Row(
  children: [
    Expanded(child:  _buildDateField(
      'Start Date',
      dobStartController,
      dobStartFocus,
      "Select Date",
      onDateChanged: (date) {
        setState(() {
          selectedStartDate = date;
        });
      },
    ),),
    SizedBox(width: 50,),
    Expanded(child:  _buildDateField(
      'End date',
      dobEndController,
      dobEndFocus,
      "Select Date",
      onDateChanged: (date) {
        setState(() {
          selectedEndDate = date;
        });
      },
    ),),
  ],
),

                const SizedBox(height: 24),

                _buildField(
                  "Description",
                  descriptionController,
                  maxLines: 4,
                ),
                const SizedBox(height: 40),

                _buildActionButtons(state),
              ],
            ),
          ),
        ),
      ),
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
        const Text(
          "Department Name",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
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
                  color: isExpanded ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                  width: isExpanded ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: isExpanded ? const Color(0xFF2563EB) : const Color(0xFF94A3B8), size: 20),
                      const SizedBox(width: 12),
                      Text(displayValue, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF94A3B8)),
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${department.name} (${department.headName})",
                            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                          ),
                        ),
                        if (displayValue == department.name)
                          const Icon(Icons.check, color: Color(0xFF2563EB), size: 18),
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
  Widget _buildSidebar() {
    return Container(
      width: 250,
      margin: const EdgeInsetsGeometry.directional(
        start: 30,
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
                  builder: (context) => const AdminProfileScreen(),
                ),
              );
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateUserScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            Icons.folder_copy_outlined,
            Icons.folder_copy_rounded,
            'Create Departments',
            'Create Departments',
                () {

            },
          ),
          _buildMenuItem(
            Icons.calendar_month,
            Icons.calendar_month_outlined,
            'Create Years',
            'Create Years',
                () {

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

  Widget _buildDateField(
      String label,
      TextEditingController controller,
      FocusNode focusNode,
      String hint,
      {
        required Function(DateTime) onDateChanged,
      }
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
                    onDateChanged(picked);


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

}

