import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/draft/test_cubit.dart';
import 'package:lms/features/draft/test_models.dart';
import 'package:lms/features/draft/test_screen.dart';
import 'package:lms/features/draft/test_states.dart';
import 'dart:html' as html;
import 'package:flutter/widgets.dart';
import 'package:lms/features/screens/get_department/get_All_departments/state_managments/cubit.dart';
import 'package:lms/features/screens/get_department/get_All_departments/state_managments/states.dart';
import 'package:lms/features/screens/get_department/get_All_departments/update_view.dart';
import 'package:lms/features/screens/get_years/get_All_years/state_mangement/cubit.dart';
import 'package:lms/features/screens/get_years/get_All_years/state_mangement/states.dart';

import '../../../../core/cons/Colors/app_colors.dart';
import '../../../../core/helpers/logout_server/logout.dart';
import '../../Announcement/view.dart';
import '../../Create_department/view.dart';
import '../../Create_user/View.dart';
import '../../add_course/Adding_view.dart';
import '../../courses/admin/view.dart';
import '../../create_squadron/view.dart';
import '../../create_years/view.dart';
import '../../get_department/get_All_departments/view.dart';
import '../../get_users/view.dart';
import '../../profiles/admin_profile/view.dart';
import 'all_model/model.dart';


String selectedMenuItem = 'All Years';
String? hoveredMenuItem;
bool isLogoutHovered = false;


class YearsScreen extends StatefulWidget {
  const YearsScreen({super.key});

  @override
  State<YearsScreen> createState() => _DepartmentsScreenState();
}


class _DepartmentsScreenState extends State<YearsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllYearsCubit()..fetchYearss(),
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
          appBar: AppBar(title: const Text("Years")),
          body: BlocBuilder<AllYearsCubit, AllYearsState>(
            builder: (context, state) {
              if (state is YearsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is YearsError) {
                return Center(child: Text(state.message));
              }

              if (state is YearsLoaded) {
                return  Row(
                  children: [
                    _buildSidebar(),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,

                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,

                            child: DataTable(
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("Start Date")),
                                DataColumn(label: Text("End Date")),
                                DataColumn(label: Text("Total Courses")),
                                DataColumn(label: Text("Total Years")),
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Dep Name")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: state.years
                                  .map((year) => _buildRow(context, year))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );

              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, GetAllYearModel year) {
    return DataRow(
      cells: [
        DataCell(Text(year.name)),
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              year.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),


        DataCell(Text(formatDate(year.startDate))),
        DataCell(Text(formatDate(year.endDate))),
        DataCell(Text(year.totalCourses.toString())),
        DataCell(Text(year.totalHours.toString())),
        DataCell(Text(year.id.toString())),
        DataCell(Text(year.departmentName)),


        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AllYearsCubit>(),
                        // child: UpdateDepartmentScreen(department: dep),
                      ),
                    ),
                  );                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(context, year.id);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }



  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Year"),
        content: const Text("Are you sure you want to delete this year?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AllYearsCubit>().deleteYear(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
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
      child: ListView(
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
            Icons.event_available,
            Icons.event_note_outlined,
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
            Icons.supervised_user_circle_rounded,
            Icons.supervised_user_circle_outlined,
            'All Users',
            'All Users',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  GetUsersPage(),
                ),
              );

            },
          ),
          _buildMenuItem(
            Icons.school_outlined,
            Icons.school,
            'All Departments',
            'All Departments',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  DepartmentsScreen(),
                ),
              );



            },
          ),
          _buildMenuItem(
            Icons.school_outlined,
            Icons.school,
            'All Years',
            'All Years',
                () {




            },
          ),
          _buildMenuItem(
            Icons.airplanemode_active,
            Icons.airplanemode_active_rounded,
            'Create Squadrons',
            'Create Squadrons',
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CreateSquadronsPage(),
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
}
