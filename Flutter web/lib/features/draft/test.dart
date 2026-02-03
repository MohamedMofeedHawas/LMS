//
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lms/features/draft/test_cubit.dart';
// import 'package:lms/features/draft/test_models.dart';
// import 'package:lms/features/draft/test_states.dart';
//
// import '../../core/cons/Colors/app_colors.dart';
// import '../../core/helpers/logout_server/logout.dart';
// import '../screens/Announcement/view.dart';
// import '../screens/Create_department/view.dart';
// import '../screens/Create_user/View.dart';
// import '../screens/add_course/Adding_view.dart';
// import '../screens/courses/admin/view.dart';
// import '../screens/create_squadron/view.dart';
// import '../screens/create_years/view.dart';
// import '../screens/profiles/admin_profile/view.dart';
//
// class GetUsersPage extends StatelessWidget {
//   const GetUsersPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => GetUsersCubit(dio: Dio()),
//       child: const GetUsersScreen(),
//     );
//   }
// }
//
// class GetUsersScreen extends StatefulWidget {
//   const GetUsersScreen({super.key});
//
//   @override
//   State<GetUsersScreen> createState() => _GetUsersScreenState();
// }
//
// class _GetUsersScreenState extends State<GetUsersScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   String selectedMenuItem = 'All Users';
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<GetUsersCubit>().fetchUsers();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             MYColors.gradientColor_3,
//             MYColors.gradientColor_2.withValues(alpha: 0.25),
//             MYColors.gradientColor_3,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Scaffold(
//         body: BlocListener<GetUsersCubit, GetUsersState>(
//           listener: (context, state) {
//             if (state is DeleteUserSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.green,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             }
//
//             if (state is DeleteUserError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                   duration: const Duration(seconds: 3),
//                 ),
//               );
//             }
//             if (state is DeactivateUserSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: [
//                       const Icon(Icons.check_circle, color: Colors.white),
//                       const SizedBox(width: 8),
//                       Text(state.message),
//                     ],
//                   ),
//                   backgroundColor: Colors.orange,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             }
//
//             if (state is DeactivateUserError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                   duration: const Duration(seconds: 3),
//                 ),
//               );
//             }
//           },
//           child: Row(
//             children: [
//               _buildSidebar(),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsetsGeometry.all(20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     children: [
//                       BlocBuilder<GetUsersCubit, GetUsersState>(
//                         builder: (context, state) {
//                           if (state is GetUsersLoaded) {
//                             final users = state.usersResponse.users;
//                             final totalUsers = state.usersResponse.totalCount;
//                             final totalAdmins = users.where((u) => u.role == 'Admin').length;
//                             final totalInstructors = users.where((u) => u.role == 'Instructor').length;
//                             final totalStudents = users.where((u) => u.role == 'Student').length;
//
//                             return Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: _StatCard(
//                                       title: 'Total Users',
//                                       count: totalUsers,
//                                       icon: Icons.people,
//                                       color: const Color(0xFF1849A9),
//                                       gradient: const LinearGradient(
//                                         colors: [Color(0xFF1849A9), Color(0xFF53B1FD)],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: _StatCard(
//                                       title: 'Total Admins',
//                                       count: totalAdmins,
//                                       icon: Icons.admin_panel_settings,
//                                       color: Colors.purple,
//                                       gradient: LinearGradient(
//                                         colors: [Colors.purple.shade600, Colors.purple.shade300],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: _StatCard(
//                                       title: 'Total Instructors',
//                                       count: totalInstructors,
//                                       icon: Icons.school,
//                                       color: Colors.orange,
//                                       gradient: LinearGradient(
//                                         colors: [Colors.orange.shade600, Colors.orange.shade300],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: _StatCard(
//                                       title: 'Total Students',
//                                       count: totalStudents,
//                                       icon: Icons.person,
//                                       color: Colors.green,
//                                       gradient: LinearGradient(
//                                         colors: [Colors.green.shade600, Colors.green.shade300],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return const SizedBox.shrink();
//                         },
//                       ),
//
//                       Expanded(
//                         child: BlocBuilder<GetUsersCubit, GetUsersState>(
//                           builder: (context, state) {
//                             if (state is GetUsersLoading || state is DeleteUserLoading) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//
//                             if (state is GetUsersError) {
//                               return Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//                                     const SizedBox(height: 16),
//                                     Text(
//                                       state.message,
//                                       style: const TextStyle(color: Colors.red),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     const SizedBox(height: 16),
//                                     ElevatedButton.icon(
//                                       onPressed: () => context.read<GetUsersCubit>().fetchUsers(),
//                                       icon: const Icon(Icons.refresh),
//                                       label: const Text('Retry'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//
//                             if (state is GetUsersLoaded) {
//                               final users = state.usersResponse.users;
//
//                               if (users.isEmpty) {
//                                 return Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
//                                       const SizedBox(height: 16),
//                                       Text(
//                                         "No users found",
//                                         style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }
//
//                               return RefreshIndicator(
//                                 onRefresh: () async => context.read<GetUsersCubit>().fetchUsers(),
//                                 child: SingleChildScrollView(
//                                   controller: _scrollController,
//                                   child: SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: DataTable(
//                                         headingRowHeight: 60,
//                                         dataRowHeight: 70,
//                                         headingRowColor: MaterialStateProperty.all(const Color(0xFF1849A9)),
//                                         border: TableBorder.all(
//                                           color: Colors.grey.shade200,
//                                           width: 1,
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         columnSpacing: 24,
//                                         horizontalMargin: 20,
//                                         columns: const [
//                                           DataColumn(label: Text('N_ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Squadron', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                           DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))),
//                                         ],
//                                         rows: List.generate(users.length, (index) {
//                                           final user = users[index];
//
//                                           Color statusColor;
//                                           Color statusTextColor;
//                                           String statusText;
//
//                                           if (user.accountStatus.toLowerCase() == 'active') {
//                                             statusColor = Colors.blue.shade100;
//                                             statusTextColor = Colors.blue.shade800;
//                                             statusText = 'Active';
//                                           } else if (user.accountStatus.toLowerCase() == 'disabled') {
//                                             statusColor = Colors.red.shade100;
//                                             statusTextColor = Colors.red.shade800;
//                                             statusText = 'Inactive';
//                                           } else {
//                                             statusColor = Colors.grey.shade300;
//                                             statusTextColor = Colors.grey.shade800;
//                                             statusText = 'Pending';
//                                           }
//
//                                           return DataRow(
//                                             cells: [
//                                               DataCell(Container(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey.shade200,
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Text('${user.nationalId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//                                               )),
//                                               DataCell(CircleAvatar(
//                                                 radius: 24,
//                                                 backgroundColor: Colors.blue.shade100,
//                                                 backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
//                                                 child: user.profileImageUrl == null
//                                                     ? Text(user.fullName[0].toUpperCase(), style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 18))
//                                                     : null,
//                                               )),
//                                               DataCell(SizedBox(width: 150, child: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis))),
//                                               DataCell(SizedBox(width: 200, child: Text(user.email, style: TextStyle(color: Colors.grey.shade700, fontSize: 13), overflow: TextOverflow.ellipsis))),
//                                               DataCell(_RoleBadge(role: user.role)),
//                                               DataCell(SizedBox(width: 180, child: _InfoBadge(icon: Icons.business, text: user.academicInfo?.department?.name ?? 'N/A', color: Colors.purple))),
//                                               DataCell(SizedBox(width: 120, child: _InfoBadge(icon: Icons.calendar_today, text: user.academicInfo?.year?.name ?? 'N/A', color: Colors.orange))),
//                                               DataCell(SizedBox(width: 150, child: _InfoBadge(icon: Icons.group, text: user.academicInfo?.squadron?.name ?? 'N/A', color: Colors.teal))),
//                                               DataCell(Container(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                                 decoration: BoxDecoration(
//                                                   color: statusColor,
//                                                   borderRadius: BorderRadius.circular(20),
//                                                   border: Border.all(color: statusTextColor.withOpacity(0.3)),
//                                                 ),
//                                                 child: Text(statusText, style: TextStyle(color: statusTextColor, fontWeight: FontWeight.w600, fontSize: 12)),
//                                               )),
//                                               DataCell(Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   IconButton(
//                                                     icon: const Icon(Icons.visibility, size: 20),
//                                                     color: Colors.blue,
//                                                     onPressed: () => _showUserDetailsDialog(user, context),
//                                                     tooltip: 'View Details',
//                                                   ),
//                                                   IconButton(
//                                                     icon: const Icon(Icons.edit, size: 20),
//                                                     color: Colors.green,
//                                                     onPressed: () {},
//                                                     tooltip: 'Edit',
//                                                   ),
//                                                   if (user.accountStatus.toLowerCase() == 'active')
//                                                     IconButton(
//                                                       icon: const Icon(Icons.block, size: 20),
//                                                       color: Colors.orange,
//                                                       onPressed: () => _showDeactivateDialog(context, user),
//                                                       tooltip: 'Deactivate User',
//                                                     ),
//                                                   // else if (user.accountStatus.toLowerCase() == 'disabled')
//                                                   //   IconButton(
//                                                   //     icon: const Icon(Icons.check_circle, size: 20),
//                                                   //     color: Colors.green.shade700,
//                                                   //     onPressed: () => _showActivateDialog(context, user),
//                                                   //     tooltip: 'Activate User',
//                                                   //   ),
//                                                   IconButton(
//                                                     icon: const Icon(Icons.delete, size: 20),
//                                                     color: Colors.red,
//                                                     onPressed: () => _showDeleteDialog(context, user),
//                                                     tooltip: 'Delete',
//                                                   ),
//                                                 ],
//                                               )),
//                                             ],
//                                           );
//                                         }),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }
//
//                             return const SizedBox.shrink();
//                           },
//                         ),
//                       ),
//
//                       BlocBuilder<GetUsersCubit, GetUsersState>(
//                         builder: (context, state) {
//                           if (state is GetUsersLoaded) {
//                             final int currentPage = state.currentPage;
//                             final int totalPages = state.usersResponse.totalPages;
//                             final bool hasNext = state.usersResponse.hasNextPage;
//                             final bool hasPrevious = state.usersResponse.hasPreviousPage;
//
//                             return Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     MYColors.gradientColor_3,
//                                     MYColors.gradientColor_2.withValues(alpha: 0.2,)]),
//
//                                 border: Border(top: BorderSide(color: Colors.grey.shade200)),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed: hasPrevious ? () => context.read<GetUsersCubit>().goToPage(currentPage - 1) : null,
//                                     icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
//                                     label: const Text('Previous'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: hasPrevious ? const Color(0xFF1849A9) : Colors.grey.shade300,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(colors: [Color(0xFF1849A9), Color(0xFF53B1FD)]),
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const Icon(Icons.library_books_rounded, color: Colors.white, size: 18),
//                                         const SizedBox(width: 8),
//                                         Text('Page $currentPage', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                                         const SizedBox(width: 4),
//                                         Text('of $totalPages', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
//                                       ],
//                                     ),
//                                   ),
//                                   ElevatedButton.icon(
//                                     onPressed: hasNext ? () => context.read<GetUsersCubit>().goToPage(currentPage + 1) : null,
//                                     label: const Text('Next'),
//                                     icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: hasNext ? const Color(0xFF1849A9) : Colors.grey.shade300,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return const SizedBox.shrink();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   void _showDeactivateDialog(BuildContext parentContext, GetUserModel user) {
//     showDialog(
//       context: parentContext,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.block, color: Colors.orange, size: 28),
//             const SizedBox(width: 12),
//             const Text('Deactivate User'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to deactivate "${user.fullName}"?',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.orange.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'This user will not be able to access the system.',
//                       style: TextStyle(
//                         color: Colors.orange.shade900,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () {
//               parentContext.read<GetUsersCubit>().deactivateUser(user.id);
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.block, size: 18),
//             label: const Text('Deactivate'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showActivateDialog(BuildContext parentContext, GetUserModel user) {
//     showDialog(
//       context: parentContext,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green.shade700, size: 28),
//             const SizedBox(width: 12),
//             const Text('Activate User'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to activate "${user.fullName}"?',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.green.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'This user will regain access to the system.',
//                       style: TextStyle(
//                         color: Colors.green.shade900,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.shade700,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () {
//               parentContext.read<GetUsersCubit>().activateUser(user.id);
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.check_circle, size: 18),
//             label: const Text('Activate'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteDialog(BuildContext parentContext, GetUserModel user) {
//     showDialog(
//       context: parentContext,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete User'),
//         content: Text('Are you sure you want to delete "${user.fullName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () {
//               parentContext.read<GetUsersCubit>().deleteUser(user.id);
//               Navigator.of(context).pop();
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebar() {
//     return Container(
//       width: 250,
//       margin: const EdgeInsets.fromLTRB(40, 50, 0, 50),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ListView(
//         children: [
//           const SizedBox(height: 40),
//           _buildMenuItem(Icons.person_outline, Icons.person, 'Profile', 'Profile', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminProfileScreen()));
//           }),
//           _buildMenuItem(Icons.book_outlined, Icons.book, 'My Courses', 'My Courses', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminCourseScreen()));
//           }),
//           _buildMenuItem(Icons.notifications_active_outlined, Icons.notifications_active_rounded, 'Announcements', 'Announcements', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnnouncementScreen()));
//           }),
//           _buildMenuItem(Icons.person_add_alt_1_outlined, Icons.person_add_alt_1, 'Create Users', 'Create users', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateUserScreen()));
//           }),
//           _buildMenuItem(Icons.folder_copy_outlined, Icons.folder_copy_rounded, 'Create Departments', 'Create Departments', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateDepartmentPage()));
//           }),
//           _buildMenuItem(Icons.calendar_month, Icons.calendar_month_outlined, 'Create Years', 'Create Years', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateYearPage()));
//           }),
//           _buildMenuItem(Icons.event_available, Icons.event_note_outlined, 'Create New Course', 'Create New Course', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateNewCoursePage()));
//           }),
//           _buildMenuItem(Icons.supervised_user_circle_rounded, Icons.supervised_user_circle_outlined, 'All Users', 'All Users', () {}),
//           _buildMenuItem(Icons.airplanemode_active, Icons.airplanemode_active_rounded, 'Create Squadrons', 'Create Squadrons', () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateSquadronsPage()));
//           }),
//           _buildMenuItem(Icons.grade_outlined, Icons.grade, 'Grades overview', 'Grades overview', () {}),
//           const Spacer(),
//           _buildLogoutButton(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton() {
//     return InkWell(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Logout'),
//             content: const Text('Are you sure you want to logout?'),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//               ElevatedButton(
//                 onPressed: () async => await LogoutServer.logout(),
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
//                 child: const Text('Logout'),
//               ),
//             ],
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: const [
//             Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
//             SizedBox(width: 12),
//             Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(IconData outlinedIcon, IconData filledIcon, String title, String value, VoidCallback onTap) {
//     final isSelected = selectedMenuItem == value;
//
//     return InkWell(
//       onTap: () {
//         setState(() => selectedMenuItem = value);
//         onTap();
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(isSelected ? filledIcon : outlinedIcon, color: isSelected ? Colors.white : const Color(0xFF64748B), size: 20),
//             const SizedBox(width: 12),
//             Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final IconData icon;
//   final Color color;
//   final Gradient gradient;
//
//   const _StatCard({
//     required this.title,
//     required this.count,
//     required this.icon,
//     required this.color,
//     required this.gradient,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: Colors.white, size: 28),
//                 ),
//                 Text('$count', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _RoleBadge extends StatelessWidget {
//   final String role;
//
//   const _RoleBadge({required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     Color bgColor;
//     Color textColor;
//
//     if (role == 'Admin') {
//       bgColor = Colors.purple.shade100;
//       textColor = Colors.purple.shade800;
//     } else if (role == 'Instructor') {
//       bgColor = Colors.orange.shade100;
//       textColor = Colors.orange.shade800;
//     } else {
//       bgColor = Colors.green.shade100;
//       textColor = Colors.green.shade800;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
//       child: Text(role, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 12)),
//     );
//   }
// }
//
// class _InfoBadge extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color color;
//
//   const _InfoBadge({required this.icon, required this.text, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     final isNA = text == 'N/A';
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isNA ? Colors.grey.shade200 : color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: isNA ? Colors.grey.shade400 : color.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: isNA ? Colors.grey.shade600 : color.withOpacity(0.8)),
//           const SizedBox(width: 6),
//           Expanded(child: Text(text, style: TextStyle(color: isNA ? Colors.grey.shade600 : color.withOpacity(0.8), fontWeight: FontWeight.w500, fontSize: 12), overflow: TextOverflow.ellipsis)),
//         ],
//       ),
//     );
//   }
// }
//
// void _showUserDetailsDialog(GetUserModel user, BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.blue.shade100,
//                     backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
//                     child: user.profileImageUrl == null ? Text(user.fullName[0].toUpperCase(), style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 32)) : null,
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                         Text(user.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
//                 ],
//               ),
//               const Divider(height: 32),
//               _DetailRow(label: 'ID', value: '#${user.id}'),
//               _DetailRow(label: 'Role', value: user.role),
//               _DetailRow(label: 'National ID', value: user.nationalId ?? 'N/A'),
//               _DetailRow(label: 'Gender', value: user.gender ?? 'N/A'),
//               _DetailRow(label: 'City', value: user.city ?? 'N/A'),
//               _DetailRow(label: 'Status', value: user.accountStatus),
//               if (user.academicInfo != null) ...[
//                 const Divider(height: 32),
//                 Text('Academic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
//                 const SizedBox(height: 12),
//                 _DetailRow(label: 'Department', value: user.academicInfo!.department?.name ?? 'N/A'),
//                 _DetailRow(label: 'Year', value: user.academicInfo!.year?.name ?? 'N/A'),
//                 _DetailRow(label: 'Squadron', value: user.academicInfo!.squadron?.name ?? 'N/A'),
//                 _DetailRow(label: 'Admission Year', value: user.academicInfo!.admissionYear.toString()),
//               ],
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _DetailRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(width: 120, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700))),
//           Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
//         ],
//       ),
//     );
//   }
// }

