import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lms/features/screens/courses/student/view.dart';
import 'package:lms/features/screens/profiles/student_profile/state_mangement/cubit.dart';
import 'package:lms/features/screens/profiles/student_profile/state_mangement/states.dart';

import '../../../../core/cons/Colors/app_colors.dart';
import '../../../../core/helpers/logout_server/logout.dart';
import '../../Announcement/view.dart';
import 'ProfileModel/view.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<StudentProfileScreen> {
  Uint8List? _webImage;
  String selectedMenuItem = 'Profile';
  bool isNextButtonHovered = false;
  String? hoveredMenuItem;
  bool isLogoutHovered = false;
  bool isProfilePictureHovered = false;
  String selectedStartYear = "2020";
  String selectedEndYear = "2025";

  bool isStartExpanded = false;
  bool isEndExpanded = false;

  List<String> yearsList = [for (int y = 1980; y <= 2060; y++) y.toString()];

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode nationalIdFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode yearLevelFocus = FocusNode();
  final FocusNode departmentFocus = FocusNode();
  final FocusNode squadronFocus = FocusNode();


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController yearLevelController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController squadronController = TextEditingController();


  String selectedNationality = 'Egyptian';
  String selectedCity = 'Cairo';
  bool isNationalityExpanded = false;
  bool isCityExpanded = false;

  final List<String> nationalities = [
    'Egyptian',
    'American',
    'British',
    'Canadian',
    'French',
    'German',
    'Italian',
    'Spanish',
    'Indian',
    'Chinese',
    'Japanese',
    'Australian',
    'Brazilian',
    'Mexican',
    'Russian',
    'South African',
  ];

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

  @override
  void dispose() {
    yearLevelController.dispose();
    departmentController.dispose();
    squadronController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    dobController.dispose();
    addressController.dispose();
    fullNameFocus.dispose();
    emailFocus.dispose();
    nationalIdFocus.dispose();
    dobFocus.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileCubit()..getProfile(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                Expanded(
                  child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
                    builder: (context, state) {
                      if (state is StudentProfileLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is StudentProfileError) {
                        return Center(child: Text(state.message));
                      } else if (state is StudentProfileLoaded) {
                        final user = state.profile.user;
                        return _buildProfileContent(user: user);
                      }
                      // Default state (initial)
                      return const Center(child: Text('Loading...'));
                    },
                  ),
                ),
              ],
            ),
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
            () {},
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
                  builder: (context) => const StudentCourseScreen(),
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
          ),          _buildMenuItem(
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

  Widget _buildProfileContent({required User user}) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Your Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Here are all your personal details that you can view and update anytime',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 32),
                _buildProfilePicture(userImageUrl: user.profileImageUrl),
                const SizedBox(height: 24),
                _buildTextField(
                  'Full Name',
                  fullNameController,
                  fullNameFocus,
                  Icons.person,
                  user.fullName,
                  true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Email address',
                  emailController,
                  emailFocus,
                  Icons.email,
                  user.email,
                  true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'National ID',
                  nationalIdController,
                  nationalIdFocus,
                  Icons.badge,
                  user.nationalId,
                  true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Department Name',
                  departmentController,
                  departmentFocus,
                  Icons.school,
                  user.academicInfo.department.name,
                  true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Squadron Name',
                  squadronController,
                  squadronFocus,
                  Icons.group,
                  user.academicInfo.squadron.name,
                  true,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  'Date of Birth',
                  dobController,
                  dobFocus,
                  user.dateOfBirth ?? "Select Date",
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Year Level',
                  yearLevelController,
                  yearLevelFocus,
                  Icons.school,
                  user.academicInfo.year.name.toString(),
                  true,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
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
                  () {
                    setState(() {
                      isCityExpanded = !isCityExpanded;
                      isNationalityExpanded = false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Row(
                //   children: [
                //     Expanded(
                //       child: _buildDropdownField(
                //         "Start Date",
                //         selectedStartYear,
                //         yearsList,
                //         isStartExpanded,
                //             (value) {
                //           setState(() {
                //             selectedStartYear = value;
                //             isStartExpanded = false;
                //           });
                //         },
                //             () {
                //           setState(() {
                //             isStartExpanded = !isStartExpanded;
                //             isEndExpanded = false;
                //           });
                //         },
                //       ),
                //     ),
                //     const SizedBox(width: 20),
                //     Expanded(
                //       child: _buildDropdownField(
                //         "End Date",
                //         selectedEndYear,
                //         yearsList,
                //         isEndExpanded,
                //             (value) {
                //           setState(() {
                //             selectedEndYear = value;
                //             isEndExpanded = false;
                //           });
                //         },
                //             () {
                //           setState(() {
                //             isEndExpanded = !isEndExpanded;
                //             isStartExpanded = false;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 32),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildProfileContent({required User user}) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Container(
  //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //         constraints: const BoxConstraints(maxWidth: 1132),
  //         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.08),
  //               blurRadius: 20,
  //               offset: const Offset(0, 4),
  //               spreadRadius: 2,
  //             ),
  //           ],
  //         ),
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.symmetric(horizontal: 40),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               const Text(
  //                 'Your Profile',
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w700,
  //                   color: Color(0xFF2563EB),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text(
  //                 'Here are all your personal details that you can view and update anytime',
  //                 style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
  //               ),
  //               const SizedBox(height: 32),
  //               _buildProfilePicture(),
  //               const SizedBox(height: 24),
  //               _buildTextField(
  //                 'Full Name',
  //                 fullNameController,
  //                 fullNameFocus,
  //                 Icons.person,
  //                 "Mohamed Mofeed",
  //               ),
  //               const SizedBox(height: 16),
  //               _buildTextField(
  //                 'Email address',
  //                 emailController,
  //                 emailFocus,
  //                 Icons.email,
  //                 "mohamed@gmail.com",
  //               ),
  //               const SizedBox(height: 16),
  //               _buildTextField(
  //                 'National ID',
  //                 nationalIdController,
  //                 nationalIdFocus,
  //                 Icons.badge,
  //                 "3040105050096",
  //               ),
  //               const SizedBox(height: 16),
  //               _buildDateField(
  //                 'Date of Birth',
  //                 dobController,
  //                 dobFocus,
  //                 "1/9/1975",
  //               ),
  //               const SizedBox(height: 16),
  //
  //
  //               _buildTextField(
  //                 'Year Level',
  //                 nationalIdController,
  //                 nationalIdFocus,
  //                 Icons.badge,
  //                 "Level Four",
  //               ),
  //               const SizedBox(height: 16),
  //               _buildDropdownField(
  //                 'City',
  //                 selectedCity,
  //                 cities,
  //                 isCityExpanded,
  //                     (value) {
  //                   setState(() {
  //                     selectedCity = value;
  //                     isCityExpanded = false;
  //                   });
  //                 },
  //                     () {
  //                   setState(() {
  //                     isCityExpanded = !isCityExpanded;
  //                     isNationalityExpanded = false;
  //                   });
  //                 },
  //               ),
  //               const SizedBox(height: 16),
  //
  //               // Row(
  //               //   children: [
  //               //     Expanded(
  //               //       child: _buildDropdownField(
  //               //         "Start Date",
  //               //         selectedStartYear,
  //               //         yearsList,
  //               //         isStartExpanded,
  //               //             (value) {
  //               //           setState(() {
  //               //             selectedStartYear = value;
  //               //             isStartExpanded = false;
  //               //           });
  //               //         },
  //               //             () {
  //               //           setState(() {
  //               //             isStartExpanded = !isStartExpanded;
  //               //             isEndExpanded = false;
  //               //           });
  //               //         },
  //               //       ),
  //               //     ),
  //               //     const SizedBox(width: 20),
  //               //     Expanded(
  //               //       child: _buildDropdownField(
  //               //         "End Date",
  //               //         selectedEndYear,
  //               //         yearsList,
  //               //         isEndExpanded,
  //               //             (value) {
  //               //           setState(() {
  //               //             selectedEndYear = value;
  //               //             isEndExpanded = false;
  //               //           });
  //               //         },
  //               //             () {
  //               //           setState(() {
  //               //             isEndExpanded = !isEndExpanded;
  //               //             isStartExpanded = false;
  //               //           });
  //               //         },
  //               //       ),
  //               //     ),
  //               //   ],
  //               // ),
  //
  //               const SizedBox(height: 32),
  //               _buildNextButton(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildProfilePicture({String? userImageUrl}) {
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
                    backgroundImage: _getProfileImage(userImageUrl),
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

  ImageProvider _getProfileImage(String? userImageUrl) {
    if (kIsWeb && _webImage != null) {
      return MemoryImage(_webImage!);
    }
    if (!kIsWeb && _selectedImage != null) {
      return FileImage(_selectedImage!);
    }

    if (userImageUrl != null && userImageUrl.isNotEmpty) {
      return NetworkImage(userImageUrl);
    }

    return const AssetImage('assets/images/chatbot man.png');
  }
  // Widget _buildProfilePicture() {
  //   return Center(
  //     child: MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       onEnter: (_) => setState(() => isProfilePictureHovered = true),
  //       onExit: (_) => setState(() => isProfilePictureHovered = false),
  //       child: GestureDetector(
  //         onTap: _pickImage,
  //         child: AnimatedContainer(
  //           duration: const Duration(milliseconds: 300),
  //           transform: Matrix4.identity()
  //             ..scale(isProfilePictureHovered ? 1.05 : 1.0),
  //           child: Stack(
  //             children: [
  //               Container(
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: isProfilePictureHovered
  //                         ? const Color(0xFF2563EB)
  //                         : const Color(0xFF2563EB).withOpacity(0.3),
  //                     width: isProfilePictureHovered ? 4 : 3,
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: const Color(
  //                         0xFF2563EB,
  //                       ).withOpacity(isProfilePictureHovered ? 0.3 : 0.1),
  //                       blurRadius: isProfilePictureHovered ? 20 : 10,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: 50,
  //                   backgroundImage: kIsWeb
  //                       ? (_webImage != null
  //                             ? MemoryImage(_webImage!)
  //                             : const AssetImage(
  //                                     'assets/images/chatbot man.png',
  //                                   )
  //                                   as ImageProvider)
  //                       : (_selectedImage != null
  //                             ? FileImage(_selectedImage!)
  //                             : const AssetImage(
  //                                 'assets/images/chatbot man.png',
  //                               )),
  //                 ),
  //               ),
  //
  //               if (isProfilePictureHovered)
  //                 Positioned.fill(
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Colors.black.withOpacity(0.4),
  //                     ),
  //                     child: const Center(
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(
  //                             Icons.cloud_upload_outlined,
  //                             color: Colors.white,
  //                             size: 28,
  //                           ),
  //                           SizedBox(height: 4),
  //                           Text(
  //                             'Change Photo',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 11,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //               Positioned(
  //                 bottom: 0,
  //                 right: 0,
  //                 child: AnimatedContainer(
  //                   duration: const Duration(milliseconds: 300),
  //                   transform: Matrix4.identity()
  //                     ..rotateZ(isProfilePictureHovered ? 0.2 : 0),
  //                   child: Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFF2563EB),
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: Colors.white, width: 3),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: const Color(0xFF2563EB).withOpacity(0.5),
  //                           blurRadius: isProfilePictureHovered ? 12 : 8,
  //                           offset: const Offset(0, 2),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Icon(
  //                       isProfilePictureHovered ? Icons.edit : Icons.camera_alt,
  //                       color: Colors.white,
  //                       size: 18,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFF2563EB),
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
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
    bool isReadOnly,
  ) {
    return StatefulBuilder(
      builder: (context, setFieldState) {
        bool isHovered = false;

        return AnimatedBuilder(
          animation: focusNode,
          builder: (context, child) {
            final isFocused = isReadOnly ? false : focusNode.hasFocus;
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
                  cursor: isReadOnly
                      ? SystemMouseCursors.forbidden
                      : SystemMouseCursors.text,
                  onEnter: (_) => setFieldState(() => isHovered = !isReadOnly),
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
                      readOnly: isReadOnly,
                      controller: controller,
                      focusNode: isReadOnly ? FocusNode() : focusNode,
                      enableInteractiveSelection: !isReadOnly,
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

  // Widget _buildTextField(String label,
  //     TextEditingController controller,
  //     FocusNode focusNode,
  //     IconData icon,
  //     String hint,
  //     bool isReadOnly) {
  //   return StatefulBuilder(
  //     builder: (context, setFieldState) {
  //       bool isHovered = false;
  //
  //       return AnimatedBuilder(
  //         animation: focusNode,
  //         builder: (context, child) {
  //           final isFocused = focusNode.hasFocus;
  //           final bool isActive = isFocused || isHovered;
  //
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               AnimatedDefaultTextStyle(
  //                 duration: const Duration(milliseconds: 200),
  //                 style: TextStyle(
  //                   fontSize: isActive ? 15 : 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: isFocused
  //                       ? const Color(0xFF2563EB)
  //                       : isHovered
  //                       ? const Color(0xFF3B82F6)
  //                       : const Color(0xFF2563EB),
  //                 ),
  //                 child: Text(label),
  //               ),
  //               const SizedBox(height: 8),
  //               MouseRegion(
  //                 cursor: SystemMouseCursors.text,
  //                 onEnter: (_) => setFieldState(() => isHovered = true),
  //                 onExit: (_) => setFieldState(() => isHovered = false),
  //                 child: AnimatedContainer(
  //                   duration: const Duration(milliseconds: 200),
  //                   transform: Matrix4.identity()
  //                     ..translate(0.0, isActive ? -2.0 : 0.0),
  //                   decoration: BoxDecoration(
  //                     color: isFocused
  //                         ? Colors.white
  //                         : isHovered
  //                         ? const Color(0xFFFEFEFE)
  //                         : const Color(0xFFF8FAFC),
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(
  //                       color: isFocused
  //                           ? const Color(0xFF2563EB)
  //                           : isHovered
  //                           ? const Color(0xFF93C5FD)
  //                           : const Color(0xFFE2E8F0),
  //                       width: isFocused
  //                           ? 2
  //                           : isHovered
  //                           ? 1.5
  //                           : 1,
  //                     ),
  //                     boxShadow: isFocused
  //                         ? [
  //                       BoxShadow(
  //                         color: const Color(0xFF2563EB).withOpacity(0.2),
  //                         blurRadius: 12,
  //                         offset: const Offset(0, 4),
  //                         spreadRadius: 1,
  //                       ),
  //                     ]
  //                         : isHovered
  //                         ? [
  //                       BoxShadow(
  //                         color: const Color(
  //                           0xFF2563EB,
  //                         ).withOpacity(0.08),
  //                         blurRadius: 8,
  //                         offset: const Offset(0, 2),
  //                       ),
  //                     ]
  //                         : [],
  //                   ),
  //
  //                   child: TextField(
  //                     readOnly: isReadOnly,
  //                     controller: controller,
  //                     focusNode: focusNode,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: const Color(0xFF1E293B),
  //                       fontWeight: isActive
  //                           ? FontWeight.w600
  //                           : FontWeight.w500,
  //                     ),
  //                     decoration: InputDecoration(
  //                       hintText: hint,
  //                       prefixIcon: AnimatedContainer(
  //                         duration: const Duration(milliseconds: 200),
  //                         transform: Matrix4.identity()
  //                           ..scale(isActive ? 1.1 : 1.0),
  //                         child: Icon(
  //                           icon,
  //                           color: isFocused
  //                               ? const Color(0xFF2563EB)
  //                               : isHovered
  //                               ? const Color(0xFF3B82F6)
  //                               : const Color(0xFF94A3B8),
  //                           size: 20,
  //                         ),
  //                       ),
  //                       suffixIcon: isActive
  //                           ? AnimatedOpacity(
  //                         duration: const Duration(milliseconds: 200),
  //                         opacity: isActive ? 1.0 : 0.0,
  //                         child: Icon(
  //                           isFocused ? Icons.edit : Icons.touch_app,
  //                           color: const Color(
  //                             0xFF2563EB,
  //                           ).withOpacity(0.4),
  //                           size: 18,
  //                         ),
  //                       )
  //                           : null,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         horizontal: 16,
  //                         vertical: 12,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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

  Widget _buildDropdownField(
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

  Widget _buildNextButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isNextButtonHovered = true),
      onExit: (_) => setState(() => isNextButtonHovered = false),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Profile updated successfully!'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isNextButtonHovered
                  ? [const Color(0xFF1D4ED8), const Color(0xFF2563EB)]
                  : [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isNextButtonHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                    isNextButtonHovered ? 4 : 0,
                    0,
                    0,
                  ),
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

// class StudentProfileScreen extends StatelessWidget {
//   const StudentProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//       StudentProfileCubit()
//         ..getProfile(),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Profile")),
//         body:
//         BlocBuilder<StudentProfileCubit, StudentProfileState>(
//           builder: (context, state) {
//             if (state is StudentProfileLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is StudentProfileError) {
//               return Center(child: Text(state.message));
//             } else if (state is StudentProfileLoaded) {
//               final user = state.profile.user;
//
//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Full Name: ${user.fullName}",
//                         style: const TextStyle(fontSize: 18)),
//                     const SizedBox(height: 8),
//                     Text("Email: ${user.email}",
//                         style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 8),
//                     Text("Role: ${user.role}",
//                         style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 8),
//                     Text("National ID: ${user.nationalId}",
//                         style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 16),
//
//                     if (user.role == "Student") ...[
//                       Text(
//                         "Year: ${user.academicInfo.year.name}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ],
//                 ),
//               );
//             } else {
//               return const SizedBox.shrink();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
