import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/cons/Colors/app_colors.dart';
import '../../../../core/helpers/cach_helper/shared_pref_helper.dart';
import '../../../../core/helpers/logout_server/logout.dart';
import '../../../../generated/assets.dart';
import '../../profiles/teacher_profile/view.dart';
import '../course_model/courses.dart';

class TeacherCourseScreen extends StatefulWidget {
  const TeacherCourseScreen({super.key});

  @override
  State<TeacherCourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<TeacherCourseScreen> {
  bool _isLoading = true;
  String? imageProfile;
  Map<String, dynamic> userData = {};

  // void loadImageProfile() async {
  //   imageProfile = await PrefHelper.getImageProfile();
  //   setState(() {});
  // }
  Future<void> _loadUserData() async {
    final data = await PrefHelper.getUserData();
    setState(() {
      userData = data;
    });
  }
  @override
  void initState() {
    super.initState();
    // loadImageProfile();
    _loadUserData();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  "Loading Courses...",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "inter",
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;

    return Container(
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
        body: SafeArea(
          child: Column(
            children: [
           
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen
                      ? 1400
                      : (isMediumScreen ? 1000 : double.infinity),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 40 : (isMediumScreen ? 20 : 16),
                  vertical: 20,
                ),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xffE3F6FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                 
                    Expanded(
                      flex: isLargeScreen ? 2 : 1,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xffF8FAFC),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xffE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            hintText: "Search courses...",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "inter",
                              color: Color(0xFF64748B),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                Assets.courseSearchIcon,
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  Color(0xFF64748B),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),

              
                    Row(
                      children: [
                        _buildNotificationButton(
                          icon: Assets.iconsMessageIcon,
                          onPressed: () {},
                        ),
                        SizedBox(width: 12),
                        _buildNotificationButton(
                          icon: Assets.iconsBellIcon,
                          onPressed: () {},
                        ),
                        SizedBox(width: 20),
                        _buildUserProfile(context),
                      ],
                    ),
                  ],
                ),
              ),

        
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isLargeScreen
                          ? 1400
                          : (isMediumScreen ? 1000 : double.infinity),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: isLargeScreen
                          ? 40
                          : (isMediumScreen ? 20 : 16),
                    ),
                    child: Column(
                      children: [
                    
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Welcome Back",
                                              style: TextStyle(
                                                color: Color(0xff175CD3),
                                                fontSize: isLargeScreen
                                                    ? 36
                                                    : 28,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "inter",
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Image.asset(
                                              Assets.iconsHand,
                                              width: isLargeScreen ? 32 : 24,
                                              height: isLargeScreen ? 32 : 24,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        //
                                        Text(
                                          "Here are the courses you’re currently teaching , manage your classes and track ",
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 16 : 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "inter",
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        Text(
                                          "your students’ progress easily.",
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 16 : 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "inter",
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        // Courses Container with White Background and Shadow
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.15),
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              double childAspectRatio;

                              if (constraints.maxWidth > 1200) {
                                crossAxisCount = 4;
                                childAspectRatio = 1.18;
                              } else if (constraints.maxWidth > 900) {
                                crossAxisCount = 3;
                                childAspectRatio = 1.14;
                              } else if (constraints.maxWidth > 600) {
                                crossAxisCount = 2;
                                childAspectRatio = 1.14;
                              } else {
                                crossAxisCount = 1;
                                childAspectRatio = 1.5;
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: true,
                                addSemanticIndexes: false,
                                cacheExtent: 0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  return _buildCourseCard(
                                    courses[index],
                                    index,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffE2E8F0), width: 1),
          ),
          child: Center(
            child: Badge(
              smallSize: 6,
              backgroundColor: Color(0xffFF3B30),
              offset: Offset(-1, 1),
              child: SvgPicture.asset(
                icon,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Color(0xFF175CD3),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE2E8F0), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,

            /// TODO ADJUST IMAGE
            // backgroundImage: imageProfile != null && imageProfile!.isNotEmpty
            //     ? NetworkImage(imageProfile!)
            //     : AssetImage(Assets.logo) as ImageProvider,
            backgroundImage: NetworkImage( userData["profileImageUrl"]  ?? Assets.logo),

            // NetworkImage(imageProfile!),
          ),
          SizedBox(width: 8),
          Text(
            userData["fullName"] ?? "User",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "inter",
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(width: 4),
          IconButton(
            icon:
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () => _showUserMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(dynamic course, int index) {
    return _CourseCardWidget(course: course, index: index);
  }
}

class _CourseCardWidget extends StatefulWidget {
  final dynamic course;
  final int index;

  const _CourseCardWidget({required this.course, required this.index});

  @override
  State<_CourseCardWidget> createState() => _CourseCardWidgetState();
}

class _CourseCardWidgetState extends State<_CourseCardWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("📘 Selected: ${widget.course.title}"),
              backgroundColor: Color(0xFF175CD3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        child: AnimatedScale(
          scale: isHovered ? 1.08 : 1.0,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(12),
            width: 304,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ]
                  :

              [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),

                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image - Fixed height
                SizedBox(
                  width: 304,
                  height: 164,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      widget.course.imageUrl,
                      fit: BoxFit.cover,
                      width: 304,
                      height: 164,
                      cacheWidth: 304,
                      cacheHeight: 164,
                      isAntiAlias: true,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 304,
                          height: 164,
                          color: Color(0xffF1F5F9),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Color(0xFF94A3B8),
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Course Content - Fixed height
                Expanded(
                  child: SizedBox(
                    width: 304,
                    height: 86,
                    // padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [


                            Expanded(
                              child: Text(
                                widget.course.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "inter",
                                  color: Color(0xFF175CD3),
                                ),
                                // maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Spacer(),
                            Icon(Icons.star,size: 22,color: Colors.blue,),

                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                              widget.course.subTitle,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: "inter",
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
}

void _showUserMenu(BuildContext context) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  final result = await showMenu<String>(
    context: context,
    position: position,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    items: [
      const PopupMenuItem<String>(
        value: 'profile',
        child: Row(
          children: [
            Icon(Icons.person, color: Color(0xFF175CD3)),
            SizedBox(width: 8),
            Text(
              "Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'settings',
        child: Row(
          children: [
            Icon(Icons.settings, color: Color(0xFF059669)),
            SizedBox(width: 8),
            Text(
              "Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'logout',
        child: Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  if (result == 'logout') {
    await LogoutServer.logout();
  } else if (result == 'profile') {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherProfileScreen(),));
    // TODO: Add profile action later
  } else if (result == 'settings') {
    // TODO: Add settings action later
  }
}
