// // code logout
//
// // IconButton(
// // icon: Icon(Icons.logout),
// // onPressed: () async {
// // await LogoutServer.logout();
// // },
// // )
//
//
//
// // String? email;
// //
// // @override
// // void initState() {
// //   super.initState();
// //   loadEmail();
// // }
// //
// // void loadEmail() async {
// //   email = await SharedPrefHelper.getEmail();
// //   setState(() {});
// // }
//
// // Text(email.toString()),
//
//
// //
// /*
// IconButton(onPressed: (){
//
//                               showDialog(
//                                 context: navigatorKey.currentContext!,
//                                 barrierDismissible: false,
//                                 builder: (_) => Dialog(
//                                   // backgroundColor: Colors.transparent,
//                                   insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                   child: Container(
//                                     width: 420,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           MYColors.gradientColor_3,
//                                           MYColors.gradientColor_2.withValues(alpha: 0.25),
//                                           MYColors.gradientColor_3,
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     padding: const EdgeInsets.all(20),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         SvgPicture.asset(Assets.deleteIcon, width: 60, height: 60,color: Colors.red.withValues(alpha: 0.6),),
//                                         // Icon(Icons.logout, color: Colors.red.withValues(alpha: 0.6), size: 60),
//                                         const SizedBox(height: 10),
//                                         const Text(
//                                           "Confirm Deletion",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         const Text(
//                                           "Are you sure you want to Delete This Course?",
//                                           style: TextStyle(color: Colors.white70, fontSize: 16),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         const SizedBox(height: 18),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.white,
//                                                 foregroundColor: Colors.blueGrey,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(12),
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//
//                                               },
//                                               child: const Text("No"),
//                                             ),
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.redAccent,
//                                                 foregroundColor: Colors.white,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(12),
//                                                 ),
//                                               ),
//                                               onPressed: ()  {
//                                                 final int currentIndex = widget.index;
//                                                 Navigator.of(context).pop();
//                                                 widget.onDelete(currentIndex);
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                   SnackBar(
//                                                     content: Row(
//                                                       children: [
//                                                         const Icon(Icons.check_circle, color: Colors.white),
//                                                         const SizedBox(width: 10),
//                                                         const Expanded(
//                                                           child: Text(
//                                                             'Course deleted successfully!',
//                                                             style: TextStyle(fontSize: 16),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     backgroundColor: Colors.green.shade600,
//                                                     behavior: SnackBarBehavior.floating,
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(12),
//                                                     ),
//                                                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                                     duration: const Duration(seconds: 3),
//                                                     elevation: 6,
//                                                   ),
//                                                 );
//                                               },
//                                               child: const Text("Yes"),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//
//                             }, icon: SvgPicture.asset(Assets.deleteIcon),),
//  */
//
// import 'dart:ui_web' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lms/features/draft/test_cubit.dart';
// import 'package:lms/features/draft/test_models.dart';
// import 'package:lms/features/draft/test_screen.dart';
// import 'package:lms/features/draft/test_states.dart';
// import 'dart:html' as html;
// import 'package:flutter/widgets.dart';
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
// import '../screens/get_department/get_All_departments/state_managments/cubit.dart';
// import '../screens/get_users/view.dart';
// import '../screens/profiles/admin_profile/view.dart';
//
// String selectedMenuItem = 'All Departments';
// String? hoveredMenuItem;
// bool isLogoutHovered = false;
//
// class DepartmentsScreen extends StatefulWidget {
//   const DepartmentsScreen({super.key});
//
//   @override
//   State<DepartmentsScreen> createState() => _DepartmentsScreenState();
// }
//
// class _DepartmentsScreenState extends State<DepartmentsScreen>
//     with TickerProviderStateMixin {
//   int? hoveredRowIndex;
//   String searchQuery = '';
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => DepartmentsCubit()..fetchDepartments(),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFF1E293B),
//               const Color(0xFF334155),
//               const Color(0xFF1E293B),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: _buildAppBar(),
//           body: BlocBuilder<DepartmentsCubit, DepartmentsState>(
//             builder: (context, state) {
//               if (state is DepartmentsLoading) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: const CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Color(0xFF3B82F6),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Loading Departments...',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               if (state is DepartmentsError) {
//                 return Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(30),
//                     margin: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.red.withOpacity(0.2),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFEE2E2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.error_outline,
//                             color: Color(0xFFEF4444),
//                             size: 48,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           state.message,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Color(0xFF64748B),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//
//               if (state is DepartmentsLoaded) {
//                 final filteredDepartments = state.departments.where((dep) {
//                   return dep.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//                       dep.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
//                       dep.headName.toLowerCase().contains(searchQuery.toLowerCase());
//                 }).toList();
//
//                 return Row(
//                   children: [
//                     _buildSidebar(),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           _buildSearchBar(),
//                           Expanded(
//                             child: Container(
//                               margin: const EdgeInsets.fromLTRB(20, 10, 40, 30),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 30,
//                                     offset: const Offset(0, 10),
//                                     spreadRadius: 5,
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   _buildTableHeader(filteredDepartments.length),
//                                   Expanded(
//                                     child: filteredDepartments.isEmpty
//                                         ? _buildEmptyState()
//                                         : _buildDataTable(filteredDepartments),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }
//
//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       title: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF3B82F6).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: const Icon(Icons.school, color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 15),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Departments Management',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Manage and organize your departments',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.white70,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 20, 40, 10),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.search, color: Color(0xFF64748B), size: 24),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value;
//                 });
//               },
//               decoration: const InputDecoration(
//                 hintText: 'Search departments, description, or head...',
//                 hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 15),
//               ),
//               style: const TextStyle(fontSize: 15),
//             ),
//           ),
//           if (searchQuery.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
//               onPressed: () {
//                 searchController.clear();
//                 setState(() {
//                   searchQuery = '';
//                 });
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTableHeader(int count) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF3B82F6).withOpacity(0.1),
//             const Color(0xFF8B5CF6).withOpacity(0.1),
//           ],
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3B82F6),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.table_chart, color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Departments List',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                   Text(
//                     '$count departments found',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           _buildRefreshButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRefreshButton() {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () {
//           context.read<DepartmentsCubit>().fetchDepartments();
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF3B82F6).withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: const Row(
//             children: [
//               Icon(Icons.refresh, color: Colors.white, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'Refresh',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.search_off,
//               size: 80,
//               color: Color(0xFF94A3B8),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'No departments found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Try adjusting your search criteria',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDataTable(List<GetAllDepartmentModel> departments) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           headingRowHeight: 60,
//           dataRowHeight: 80,
//           columnSpacing: 30,
//           headingRowColor: MaterialStateProperty.all(
//             const Color(0xFFF8FAFC),
//           ),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.grey.shade200,
//                 width: 1,
//               ),
//             ),
//           ),
//           columns: [
//             _buildDataColumn('Name', Icons.business),
//             _buildDataColumn('Description', Icons.description),
//             _buildDataColumn('Image', Icons.image),
//             _buildDataColumn('Head', Icons.person),
//             _buildDataColumn('Years', Icons.calendar_today),
//             _buildDataColumn('ID', Icons.tag),
//             _buildDataColumn('Actions', Icons.settings),
//           ],
//           rows: List.generate(
//             departments.length,
//                 (index) => _buildRow(context, departments[index], index),
//           ),
//         ),
//       ),
//     );
//   }
//
//   DataColumn _buildDataColumn(String label, IconData icon) {
//     return DataColumn(
//       label: Row(
//         children: [
//           Icon(icon, size: 18, color: const Color(0xFF64748B)),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Color(0xFF1E293B),
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   DataRow _buildRow(
//       BuildContext context,
//       GetAllDepartmentModel dep,
//       int index,
//       ) {
//     final isHovered = hoveredRowIndex == index;
//
//     return DataRow(
//       color: MaterialStateProperty.resolveWith<Color>(
//             (Set<MaterialState> states) {
//           if (isHovered) {
//             return const Color(0xFFF1F5F9);
//           }
//           return index.isEven ? Colors.white : const Color(0xFFFAFAFA);
//         },
//       ),
//       onSelectChanged: (_) {},
//       cells: [
//         DataCell(
//           MouseRegion(
//             cursor: SystemMouseCursors.click,
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: isHovered
//                     ? LinearGradient(
//                   colors: [
//                     const Color(0xFF3B82F6).withOpacity(0.1),
//                     const Color(0xFF8B5CF6).withOpacity(0.1),
//                   ],
//                 )
//                     : null,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     dep.name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: isHovered
//                           ? const Color(0xFF3B82F6)
//                           : const Color(0xFF1E293B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: Container(
//               constraints: const BoxConstraints(maxWidth: 250),
//               child: Text(
//                 dep.description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF64748B),
//                   height: 1.5,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: dep.imageUrl != null
//                 ? AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: isHovered
//                     ? [
//                   BoxShadow(
//                     color: const Color(0xFF3B82F6).withOpacity(0.3),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ]
//                     : [],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: WebImage(
//                   url: buildImageUrl(dep.imageUrl),
//                   width: 70,
//                   height: 50,
//                 ),
//               ),
//             )
//                 : Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F5F9),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.image_not_supported,
//                 color: Color(0xFF94A3B8),
//                 size: 20,
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF3B82F6).withOpacity(0.1),
//                     const Color(0xFF8B5CF6).withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.person, size: 16, color: Color(0xFF3B82F6)),
//                   const SizedBox(width: 6),
//                   Text(
//                     dep.headName,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: Wrap(
//               spacing: 6,
//               runSpacing: 6,
//               children: dep.years.isEmpty
//                   ? [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1F5F9),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Text(
//                     'No years',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Color(0xFF94A3B8),
//                     ),
//                   ),
//                 ),
//               ]
//                   : dep.years.take(3).map((year) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF10B981), Color(0xFF059669)],
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF10B981).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     year.name,
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F5F9),
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(
//                   color: const Color(0xFFE2E8F0),
//                 ),
//               ),
//               child: Text(
//                 '#${dep.id}',
//                 style: const TextStyle(
//                   fontFamily: 'monospace',
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           MouseRegion(
//             onEnter: (_) => setState(() => hoveredRowIndex = index),
//             onExit: (_) => setState(() => hoveredRowIndex = null),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildActionButton(
//                   icon: Icons.edit,
//                   color: const Color(0xFF3B82F6),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BlocProvider.value(
//                           value: context.read<DepartmentsCubit>(),
//                           child: UpdateDepartmentScreen(department: dep),
//                         ),
//                       ),
//                     );
//                   },
//                   tooltip: 'Edit',
//                 ),
//                 const SizedBox(width: 8),
//                 _buildActionButton(
//                   icon: Icons.delete,
//                   color: const Color(0xFFEF4444),
//                   onPressed: () {
//                     _showDeleteDialog(context, dep.id);
//                   },
//                   tooltip: 'Delete',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//     required String tooltip,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: GestureDetector(
//           onTap: onPressed,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: color.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 18,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String buildImageUrl(String? imageUrl) {
//     if (imageUrl == null || imageUrl.isEmpty) return '';
//     return 'http://skylearn.runasp.net${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
//   }
//
//   void _showDeleteDialog(BuildContext context, int id) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEE2E2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.warning_amber_rounded,
//                 color: Color(0xFFEF4444),
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Delete Department",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: const Text(
//           "Are you sure you want to delete this department? This action cannot be undone.",
//           style: TextStyle(
//             fontSize: 14,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFEF4444),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: () {
//               context.read<DepartmentsCubit>().deleteDepartment(id);
//               Navigator.pop(context);
//             },
//             child: const Text(
//               "Delete",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebar() {
//     return Container(
//       width: 260,
//       margin: const EdgeInsets.fromLTRB(30, 30, 0, 30),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 30,
//             offset: const Offset(0, 10),
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.dashboard, color: Colors.white, size: 28),
//                 SizedBox(width: 12),
//                 Text(
//                   'Dashboard',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               children: [
//                 _buildMenuItem(
//                   Icons.person_outline,
//                   Icons.person,
//                   'Profile',
//                   'Profile',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AdminProfileScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.book_outlined,
//                   Icons.book,
//                   'My Courses',
//                   'My Courses',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AdminCourseScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.notifications_active_outlined,
//                   Icons.notifications_active_rounded,
//                   'Announcements',
//                   'Announcements',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AnnouncementScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.person_add_alt_1_outlined,
//                   Icons.person_add_alt_1,
//                   'Create Users',
//                   'Create users',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CreateUserScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.folder_copy_outlined,
//                   Icons.folder_copy_rounded,
//                   'Create Departments',
//                   'Create Departments',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CreateDepartmentPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.calendar_month,
//                   Icons.calendar_month_outlined,
//                   'Create Years',
//                   'Create Years',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CreateYearPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.event_available,
//                   Icons.event_note_outlined,
//                   'Create New Course',
//                   'Create New Course',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CreateNewCoursePage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.supervised_user_circle_rounded,
//                   Icons.supervised_user_circle_outlined,
//                   'All Users',
//                   'All Users',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => GetUsersPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.school_outlined,
//                   Icons.school,
//                   'All Departments',
//                   'All Departments',
//                       () {},
//                 ),
//                 _buildMenuItem(
//                   Icons.airplanemode_active,
//                   Icons.airplanemode_active_rounded,
//                   'Create Squadrons',
//                   'Create Squadrons',
//                       () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CreateSquadronsPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.grade_outlined,
//                   Icons.grade,
//                   'Grades overview',
//                   'Grades overview',
//                       () {},
//                 ),
//               ],
//             ),
//           ),
//           _buildLogoutButton(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(
//       IconData outlinedIcon,
//       IconData filledIcon,
//       String title,
//       String value,
//       VoidCallback onTap,
//       ) {
//     final isSelected = selectedMenuItem == value;
//     final isHovered = hoveredMenuItem == value;
//
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       onEnter: (_) => setState(() => hoveredMenuItem = value),
//       onExit: (_) => setState(() => hoveredMenuItem = null),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedMenuItem = value;
//           });
//           onTap();
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             gradient: isSelected
//                 ? const LinearGradient(
//               colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//             )
//                 : null,
//             color: isHovered && !isSelected
//                 ? const Color(0xFFF1F5F9)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: isSelected
//                 ? [
//               BoxShadow(
//                 color: const Color(0xFF3B82F6).withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ]
//                 : [],
//           ),
//           child: Row(
//             children: [
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: Icon(
//                   isSelected ? filledIcon : outlinedIcon,
//                   key: ValueKey(isSelected),
//                   color: isSelected
//                       ? Colors.white
//                       : isHovered
//                       ? const Color(0xFF3B82F6)
//                       : const Color(0xFF64748B),
//                   size: 22,
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     color: isSelected
//                         ? Colors.white
//                         : isHovered
//                         ? const Color(0xFF1E293B)
//                         : const Color(0xFF64748B),
//                     fontSize: 14,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                   ),
//                 ),
//               ),
//               if (isSelected)
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton() {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       onEnter: (_) => setState(() => isLogoutHovered = true),
//       onExit: (_) => setState(() => isLogoutHovered = false),
//       child: GestureDetector(
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               title: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFEE2E2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.logout,
//                       color: Color(0xFFEF4444),
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Logout',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               content: const Text(
//                 'Are you sure you want to logout?',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Color(0xFF64748B),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await LogoutServer.logout();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFEF4444),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     'Logout',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.symmetric(horizontal: 12),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             color: isLogoutHovered
//                 ? const Color(0xFFFEE2E2)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isLogoutHovered
//                   ? const Color(0xFFEF4444).withOpacity(0.3)
//                   : Colors.transparent,
//               width: 1.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.logout,
//                 color: const Color(0xFFEF4444),
//                 size: 22,
//               ),
//               const SizedBox(width: 14),
//               const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Color(0xFFEF4444),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WebImage extends StatelessWidget {
//   final String url;
//   final double width;
//   final double height;
//
//   const WebImage({
//     super.key,
//     required this.url,
//     required this.width,
//     required this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final viewId = url;
//
//     ui.platformViewRegistry.registerViewFactory(viewId, (int _) {
//       final img = html.ImageElement()
//         ..src = url
//         ..style.width = '100%'
//         ..style.height = '100%'
//         ..style.objectFit = 'cover';
//
//       return img;
//     });
//
//     return SizedBox(
//       width: width,
//       height: height,
//       child: HtmlElementView(viewType: viewId),
//     );
//   }
// }