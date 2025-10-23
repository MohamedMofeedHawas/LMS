import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/helpers/logout_server/logout.dart';
import 'course_model/courses.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {



  // String? email;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadEmail();
  // }
  //
  // void loadEmail() async {
  //   email = await PrefHelper.getEmail();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MYColors.gradientColor_3,
            MYColors.gradientColor_1.withValues(alpha: 0.35),
            MYColors.gradientColor_3,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 1400 : (isMediumScreen ? 1000 : double.infinity),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 40 : (isMediumScreen ? 20 : 16),
                vertical: 20,
              ),
    child: Column(
      children: [
                          // Enhanced Header Section
        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
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
                              children: [
                                // Top Row - Search and User Info
                                Row(
            children: [
                                    // Search Bar
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
                                                "assets/icons/search.svg",
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

                                    // User Actions
                                    Row(
                                      children: [
                                        _buildNotificationButton(
                                          icon: "assets/icons/message-icon.svg",
                                          onPressed: () {},
                                        ),
                                        SizedBox(width: 12),
                                        _buildNotificationButton(
                                          icon: "assets/icons/bell_icon.svg",
                                          onPressed: () {},
                                        ),
                                        SizedBox(width: 20),
                                        _buildUserProfile(context),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          // Enhanced Courses Content Section
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
                                // Welcome Section
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Welcome Back",
                                                style: TextStyle(
                                                  color: Color(0xFF175CD3),
                                                  fontSize: isLargeScreen
                                                      ? 36
                                                      : 28,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "inter",
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Image.asset(
                                                "assets/icons/hand.png",
                                                width: isLargeScreen ? 32 : 24,
                                                height: isLargeScreen ? 32 : 24,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Start your learning journey now — your next big achievement starts here!",
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
                                SizedBox(height: 30),

                                // Responsive Courses Grid
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    int crossAxisCount;
                                    double childAspectRatio;

                                    if (constraints.maxWidth > 1200) {
                                      crossAxisCount = 4;
                                      childAspectRatio = 1.22; // 304/250
                                    } else if (constraints.maxWidth > 900) {
                                      crossAxisCount = 3;
                                      childAspectRatio = 1.22;
                                    } else if (constraints.maxWidth > 600) {
                                      crossAxisCount = 2;
                                      childAspectRatio = 1.22;
                                    } else {
                                      crossAxisCount = 1;
                                      childAspectRatio = 1.22;
                                    }

                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: childAspectRatio,
                                      ),
                                      itemCount: courses.length,
                                      itemBuilder: (context, index) {
                                        return _buildCourseCard(
                                            courses[index], index);
                                      },
                                    );
                                  },
                                ),
                              ],
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

  Widget _buildNotificationButton({required String icon, required VoidCallback onPressed}) {
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
            border: Border.all(
              color: Color(0xffE2E8F0),
              width: 1,
            ),
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
        border: Border.all(
          color: Color(0xffE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
                  CircleAvatar(
            radius: 16,
                    backgroundImage: AssetImage("assets/logo/logo.jpg"),
                  ),
          SizedBox(width: 8),
          Text(
            "Mohamed Ahmed",
            style: TextStyle(
              fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "inter",
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(width: 4),
          IconButton(
            icon: Icon(
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
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("📘 Selected: ${course.title}"),
                    backgroundColor: Color(0xFF175CD3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                width: 304,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image - Fixed height
                    Container(
                      width: 304,
                      height: 164,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          course.imageUrl,
                          // fit: BoxFit.cover,
                          width: 304,
                          height: 164,
                          cacheWidth: 304,
                          cacheHeight: 164,
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
                      child: Container(
                        width: 304,
                        height: 86,
                        // padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "inter",
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3),
                            Text(
                              course.subTitle,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: "inter",
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFF59E0B),
                                  size: 14,
                                ),
                      Spacer(),                              Text(
                                  "${course.rate} Complete",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
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
      },
    );
  }

  void _showUserMenu(BuildContext context) async {
                      final RenderBox button = context.findRenderObject() as RenderBox;
                      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                        ),
                        Offset.zero & overlay.size,
                      );

                      final result = await showMenu<String>(
                        context: context,
                        position: position,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                        // TODO: Add profile action later
                      } else if (result == 'settings') {
                        // TODO: Add settings action later
                      }
  }
}

