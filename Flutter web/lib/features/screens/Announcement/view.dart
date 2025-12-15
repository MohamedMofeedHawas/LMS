import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/cons/Colors/app_colors.dart';
import '../../../../core/helpers/logout_server/logout.dart';
import '../../../../generated/assets.dart';
import 'package:fl_chart/fl_chart.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<AnnouncementScreen> {
  bool _isLoading = true;



  String? imageProfile;



  // void loadImageProfile() async {
  //   imageProfile = await PrefHelper.getImageProfile();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // loadImageProfile();

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
                  "Loading Announcements...",
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
                            hintText: "Search Announcements...",
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
                                            SvgPicture.asset(
                                              Assets.listAnnouncementIcon
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              "Announcements",
                                              style: TextStyle(
                                                color: Color(0xff175CD3),

                                                fontSize: isLargeScreen
                                                    ? 36
                                                    : 28,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "inter",
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Stay updated with the latest announcements, course updates, and important notifications from your",
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 16 : 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "inter",
                                            color: Color(0xFF64748B).withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Text(
                                          "instructors and university",
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 16 : 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "inter",
                                            color: Color(0xFF64748B).withValues(alpha: 0.7),
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
                          height:1238 ,
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
                          child: Center(
                            child:  PieChartScreen()

                          ),
                        ),



                        ]
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
      child:
      InkWell(
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

            ///TODO


            backgroundImage: NetworkImage(imageProfile ?? Assets.logo),
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



class PieChartScreen extends StatefulWidget {
  const PieChartScreen({super.key});

  @override
  State<PieChartScreen> createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isInitialized = false;
  bool _isHovered = false;
  bool _isDatePickerHovered = false;
  bool _isEditingDate = false;
  int _touchedIndex = -1;


  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _parseAndSetDate(String input, BuildContext context) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        final parsedDate = DateTime(year, month, day);

        if (parsedDate.year == year &&
            parsedDate.month == month &&
            parsedDate.day == day) {
          setState(() {
            _selectedDate = parsedDate;
            _isEditingDate = false;
            _dateController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
          });
          return;
        }
      }
    } catch (_) {
      // TODO: continue to error handler below
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid date format. Please use DD/MM/YYYY'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );

    setState(() {
      _isEditingDate = false;
    });
  }

  int _getTouchedSection(Offset localPosition) {
    const double centerSpaceRadius = 60.0;
    const double outerRadius = 100.0;

    final center = Offset(100.0, 100.0);

    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance < centerSpaceRadius || distance > outerRadius) {
      return -1;
    }

    double angle = math.atan2(dy, dx) * 180 / math.pi;
    if (angle < 0) angle += 360;
    double adjustedAngle = (angle + 90) % 360;

    if (adjustedAngle >= 0 && adjustedAngle < 288) {
      return 0;
    } else {
      return 1;
    }
  }

  PieChartData _getChartData() {
    return PieChartData(
      sectionsSpace: _isHovered ? 2 : 0,
      centerSpaceRadius: 60,
      startDegreeOffset: -90,
      sections: [
        PieChartSectionData(
          color: _touchedIndex == 0 ? Colors.blue.shade800 : Colors.blue.shade600,
          value: 80,
          title: _touchedIndex == 0 ? '80%' : '',
          radius: _touchedIndex == 0 ? 25 : 20,
          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        PieChartSectionData(
          color: _touchedIndex == 1 ? Colors.amber.shade600 : Colors.amber.shade400,
          value: 20,
          title: _touchedIndex == 1 ? '20%' : '',
          radius: _touchedIndex == 1 ? 25 : 20,
          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox.shrink();

    return Center(
      child: MouseRegion(
        onEnter: (_) {
          if (!_isHovered && mounted) {
            setState(() => _isHovered = true);
            _animationController.forward();
          }
        },
        onExit: (_) {
          if (_isHovered && mounted) {
            setState(() {
              _isHovered = false;
              _touchedIndex = -1;
            });
            _animationController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: _isHovered
                      ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.blue.shade50],
                  )
                      : null,
                  color: _isHovered ? null : Colors.white70,
                  boxShadow: _isHovered
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 5),
                    )
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                height: 385,
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _isHovered ? Colors.blue.shade700 : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.linear_scale_outlined,
                              color: _isHovered ? Colors.blue.shade700 : Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 5, backgroundColor: Colors.blue.shade600),
                              const SizedBox(width: 6),
                              Text("Present", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              CircleAvatar(radius: 5, backgroundColor: Colors.amber.shade400),
                              const SizedBox(width: 6),
                              Text("Absent", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: GestureDetector(
                          onTapDown: (details) {
                            final local = details.localPosition;
                            final section = _getTouchedSection(local);
                            if (section != _touchedIndex && mounted) {
                              setState(() {
                                _touchedIndex = section;
                              });
                            }
                          },
                          child: MouseRegion(
                            onHover: (details) {
                              final local = details.localPosition;
                              final section = _getTouchedSection(local);
                              if (section != _touchedIndex && mounted) {
                                setState(() {
                                  _touchedIndex = section;
                                });
                              }
                            },
                            onExit: (_) {
                              if (_touchedIndex != -1 && mounted) {
                                setState(() {
                                  _touchedIndex = -1;
                                });
                              }
                            },
                            child: PieChart(_getChartData()),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      MouseRegion(
                        onEnter: (_) {
                          if (!_isDatePickerHovered && mounted) {
                            setState(() => _isDatePickerHovered = true);
                          }
                        },
                        onExit: (_) {
                          if (_isDatePickerHovered && mounted) {
                            setState(() => _isDatePickerHovered = false);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: _isEditingDate ? 6 : 10),
                          decoration: BoxDecoration(
                            color: _isDatePickerHovered ? Colors.blue.shade50 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isDatePickerHovered ? Colors.blue.shade400 : Colors.grey.shade300,
                              width: 1.1,
                            ),
                            boxShadow: _isDatePickerHovered
                                ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                                : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final DateTime now = DateTime.now();
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate ?? now,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDatePickerMode: DatePickerMode.day,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Colors.blue.shade600,
                                            onPrimary: Colors.black,
                                            surface: Colors.grey.shade100,
                                            onSurface: Colors.grey.shade900,
                                            secondary: Colors.blueAccent.shade100,
                                          ),
                                          datePickerTheme: DatePickerThemeData(
                                            backgroundColor: Colors.grey.shade50,
                                            headerBackgroundColor: Colors.blueGrey.withValues(alpha: 0.8),
                                            headerForegroundColor: Colors.white,
                                            dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                                  (states) {
                                                if (states.contains(WidgetState.selected)) {
                                                  return Colors.blue.shade200;
                                                }
                                                if (states.contains(WidgetState.hovered)) {
                                                  return Colors.blue.shade50;
                                                }
                                                return null;
                                              },
                                            ),
                                            dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
                                                  (states) {
                                                if (states.contains(WidgetState.selected)) {
                                                  return Colors.black87;
                                                }
                                                return Colors.grey.shade800;
                                              },
                                            ),
                                            todayBackgroundColor: WidgetStateProperty.all(Colors.blue.shade100),
                                            todayForegroundColor: WidgetStateProperty.all(Colors.blue.shade600),
                                            yearStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            dayStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            elevation: 6,
                                          ),
                                        ),
                                        child: child!,
                                      );

                                    },
                                  );

                                  if (picked != null && mounted) {
                                    setState(() {
                                      _selectedDate = picked;
                                      _dateController.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300, width: 1.1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _selectedDate == null
                                            ? "select date"
                                            : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )



                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



