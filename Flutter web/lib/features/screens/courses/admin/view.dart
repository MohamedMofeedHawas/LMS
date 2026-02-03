
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms/core/widgets/app_bar.dart';
import 'package:lms/features/screens/Create_user/View.dart';
import 'package:lms/features/screens/get_squadron/get_all%20squadrons/view.dart';
import 'package:lms/features/screens/get_users/view.dart';

import '../../../../core/cons/Colors/app_colors.dart';
import '../../../../core/cons/context/navigation_key.dart';
import '../../../../core/helpers/logout_server/logout.dart';
import '../../../../generated/assets.dart';
import '../../../draft/comments.dart';
import '../../../draft/test.dart';
import '../../get_department/get_All_departments/view.dart';
import '../course_model/courses.dart';

class AdminCourseScreen extends StatefulWidget {
  const AdminCourseScreen({super.key});

  @override
  State<AdminCourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<AdminCourseScreen> {
  bool _isLoading = true;



  String? imageProfile;



// void loadImageProfile() async {
//   imageProfile = await PrefHelper.getImageProfile();
//   setState(() {});
// }
// List <CourseModel> allCourses = [];
@override
  void initState() {
    super.initState();
    // Simulate loading time and then show content
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    // allCourses = courses;

    // loadImageProfile();

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return
        Container(
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

    return
      Container(
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
        appBar: CustomAppBar(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Container(
              //   width: double.infinity,
              //   constraints: BoxConstraints(
              //     maxWidth: isLargeScreen
              //         ? 1400
              //         : (isMediumScreen ? 1000 : double.infinity),
              //   ),
              //   margin: EdgeInsets.symmetric(
              //     horizontal: isLargeScreen ? 40 : (isMediumScreen ? 20 : 16),
              //     vertical: 20,
              //   ),
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //
              //     color: Color(0xffE3F6FF),
              //     borderRadius: BorderRadius.circular(20),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withValues(alpha: 0.05),
              //         blurRadius: 20,
              //         spreadRadius: 0,
              //         offset: Offset(0, 10),
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           SvgPicture.asset(Assets.wing, width: 64, height: 61),
              //           SizedBox(width: 10,),
              //           Text("SkyLearn",style:
              //             TextStyle(
              //               fontFamily: "inter",
              //               fontSize: 48,
              //               fontWeight: FontWeight.w700,
              //               color: Color(0xff2E90FA)
              //
              //             ),),
              //         ],
              //
              //       ),
              //       SizedBox(width: 60,),
              //       Expanded(
              //         flex: isLargeScreen ? 2 : 1,
              //         child: Container(
              //           height: 50,
              //           decoration: BoxDecoration(
              //             color: Color(0xffF8FAFC),
              //             borderRadius: BorderRadius.circular(15),
              //             border: Border.all(
              //               color: Color(0xffE2E8F0),
              //               width: 1,
              //             ),
              //           ),
              //           child:
              //           TextFormField(
              //             decoration: InputDecoration(
              //               border: InputBorder.none,
              //               contentPadding: EdgeInsets.symmetric(
              //                 horizontal: 20,
              //                 vertical: 15,
              //               ),
              //               hintText: "Search courses...",
              //               hintStyle: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 fontFamily: "inter",
              //                 color: Color(0xFF64748B),
              //               ),
              //               prefixIcon: Padding(
              //                 padding: EdgeInsets.all(12),
              //                 child: SvgPicture.asset(
              //                   Assets.courseSearchIcon,
              //                   width: 20,
              //                   height: 20,
              //                   colorFilter: ColorFilter.mode(
              //                     Color(0xFF64748B),
              //                     BlendMode.srcIn,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //
              //       InkWell(
              //         onTap: () => _showUserMenu(context),
              //         child: Container(
              //           width: 38,
              //           height: 38,
              //           decoration: BoxDecoration(
              //             color: Colors.transparent,
              //             borderRadius: BorderRadius.circular(30),
              //             border: Border.all(color: Colors.black.withValues(alpha: 0.2), width: 2),
              //           ),
              //           child: Center(
              //             child: Icon(Icons.keyboard_arrow_down_outlined),
              //
              //           ),
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),

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
                                        Text(
                                          "Manage your classes and track your students’ progress easily.",
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
  //
  // Widget _buildNotificationButton({
  //   required String icon,
  //   required VoidCallback onPressed,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onPressed,
  //       borderRadius: BorderRadius.circular(12),
  //       child: Container(
  //         width: 40,
  //         height: 40,
  //         decoration: BoxDecoration(
  //           color: Color(0xffF8FAFC),
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: Color(0xffE2E8F0), width: 1),
  //         ),
  //         child: Center(
  //           child: Badge(
  //             smallSize: 6,
  //             backgroundColor: Color(0xffFF3B30),
  //             offset: Offset(-1, 1),
  //             child: SvgPicture.asset(
  //               icon,
  //               width: 18,
  //               height: 18,
  //               colorFilter: ColorFilter.mode(
  //                 Color(0xFF175CD3),
  //                 BlendMode.srcIn,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildUserProfile(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: Color(0xffF8FAFC),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Color(0xffE2E8F0), width: 1),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         CircleAvatar(
  //           radius: 16,
  //
  //           ///TODO
  //
  //
  //           backgroundImage: AssetImage(imageProfile ?? Assets.logo),
  //         ),
  //         SizedBox(width: 8),
  //         Text(
  //           "Mohamed Ahmed",
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             fontFamily: "inter",
  //             color: Color(0xFF1E293B),
  //           ),
  //         ),
  //         SizedBox(width: 4),
  //         IconButton(
  //           icon: Icon(
  //             Icons.keyboard_arrow_down_outlined,
  //             color: Color(0xFF64748B),
  //             size: 20,
  //           ),
  //           onPressed: () => _showUserMenu(context),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCourseCard(dynamic course, int index) {
    return _CourseCardWidget(
      course: course,
      index: index,
      onDelete: (int courseIndex) {
        setState(() {
          if (courseIndex >= 0 && courseIndex < courses.length) {
            courses.removeAt(courseIndex);
          }
        });
      },
    );
  }
}

class _CourseCardWidget extends StatefulWidget {
  final dynamic course;
  final int index;
  final ValueChanged<int> onDelete;

  const _CourseCardWidget({
    required this.course,
    required this.index,
    required this.onDelete,
  });

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => GetSquadronPage(),));

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


                            /// TODO : ADJUST EDIT COURSE
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentsScreen(),));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("data"),
                                  )
                                );

                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xff175CD3),
                                child: Center(child: Icon(Icons.edit,color: Colors.white,size: 15,)),
                                //),

                              ),
                            )
                            // Spacer(),
                            // Icon(Icons.star,size: 22,color: Colors.blue,),
                            // SvgPicture.asset(Assets.deleteIcon),
                            // IconButton(onPressed: (){
                            //
                            //   showDialog(
                            //     context: navigatorKey.currentContext!,
                            //     barrierDismissible: false,
                            //     builder: (_) => Dialog(
                            //       // backgroundColor: Colors.transparent,
                            //       insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            //       child: Container(
                            //         width: 420,
                            //         decoration: BoxDecoration(
                            //           gradient: LinearGradient(
                            //             colors: [
                            //               MYColors.gradientColor_3,
                            //               MYColors.gradientColor_2.withValues(alpha: 0.25),
                            //               MYColors.gradientColor_3,
                            //             ],
                            //             begin: Alignment.topLeft,
                            //             end: Alignment.bottomRight,
                            //           ),
                            //           borderRadius: BorderRadius.circular(20),
                            //         ),
                            //         padding: const EdgeInsets.all(20),
                            //         child: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             SvgPicture.asset(Assets.deleteIcon, width: 60, height: 60,color: Colors.red.withValues(alpha: 0.6),),
                            //             // Icon(Icons.logout, color: Colors.red.withValues(alpha: 0.6), size: 60),
                            //             const SizedBox(height: 10),
                            //             const Text(
                            //               "Confirm Deletion",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 22,
                            //                 fontWeight: FontWeight.bold,
                            //               ),
                            //             ),
                            //             const SizedBox(height: 8),
                            //             const Text(
                            //               "Are you sure you want to Delete This Course?",
                            //               style: TextStyle(color: Colors.white70, fontSize: 16),
                            //               textAlign: TextAlign.center,
                            //             ),
                            //             const SizedBox(height: 18),
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //               children: [
                            //                 ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                     backgroundColor: Colors.white,
                            //                     foregroundColor: Colors.blueGrey,
                            //                     shape: RoundedRectangleBorder(
                            //                       borderRadius: BorderRadius.circular(12),
                            //                     ),
                            //                   ),
                            //                   onPressed: () {
                            //                     Navigator.of(context).pop();
                            //
                            //                   },
                            //                   child: const Text("No"),
                            //                 ),
                            //                 ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                     backgroundColor: Colors.redAccent,
                            //                     foregroundColor: Colors.white,
                            //                     shape: RoundedRectangleBorder(
                            //                       borderRadius: BorderRadius.circular(12),
                            //                     ),
                            //                   ),
                            //                   onPressed: ()  {
                            //                     final int currentIndex = widget.index;
                            //                     Navigator.of(context).pop();
                            //                     widget.onDelete(currentIndex);
                            //                     ScaffoldMessenger.of(context).showSnackBar(
                            //                       SnackBar(
                            //                         content: Row(
                            //                           children: [
                            //                             const Icon(Icons.check_circle, color: Colors.white),
                            //                             const SizedBox(width: 10),
                            //                             const Expanded(
                            //                               child: Text(
                            //                                 'Course deleted successfully!',
                            //                                 style: TextStyle(fontSize: 16),
                            //                               ),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         backgroundColor: Colors.green.shade600,
                            //                         behavior: SnackBarBehavior.floating,
                            //                         shape: RoundedRectangleBorder(
                            //                           borderRadius: BorderRadius.circular(12),
                            //                         ),
                            //                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            //                         duration: const Duration(seconds: 3),
                            //                         elevation: 6,
                            //                       ),
                            //                     );
                            //                   },
                            //                   child: const Text("Yes"),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   );
                            //
                            // }, icon: SvgPicture.asset(Assets.deleteIcon),),

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
    // TODO: Add profile action later
  } else if (result == 'settings') {
    // TODO: Add settings action later
  }
}
