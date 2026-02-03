
import 'package:flutter/material.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/widgets/app_bar.dart';
import 'Adding_view.dart';



class CoursesManagementApp extends StatelessWidget {
  const CoursesManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courses Management Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF475569)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width < 800) {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'This view is optimized for desktop and web. Please view on admin_profile larger screen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

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
        appBar: CustomAppBar(),
        body: ScrollConfiguration(
          behavior:
          MyCustomScrollBehavior(),
          child: SingleChildScrollView(


            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenSize.height),
                child: const CoursesManagementContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
class CoursesManagementContent extends StatelessWidget {
  const CoursesManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsetsGeometry.symmetric(horizontal: 80),

      padding: const EdgeInsets.fromLTRB(100.0, 40.0, 100.0, 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white70.withValues(alpha: 0.3),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Courses Management",
                                style: TextStyle(
                                  color: Color(0xff175CD3),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "inter",
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Manage, create, and organize your platform courses.",
                            style: TextStyle(
                              fontSize: 16,
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

          const SizedBox(height: 40),

          const CourseListSection(),

          const SizedBox(height: 40),

          const FeatureCardsRow(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String instructor;
  final int students;
  final Color color;

  Course(this.title, this.instructor, this.students, this.color);
}

class CourseListSection extends StatefulWidget {
  const CourseListSection({super.key});

  @override
  State<CourseListSection> createState() => _CourseListSectionState();
}

class _CourseListSectionState extends State<CourseListSection> {
  final Color primaryColor = const Color(0xFF3B82F6);
  List<Course> _courses = [];
  final List<Color> courseColors = [
    const Color(0xFFFACC15),
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFF6366F1),
  ];

  // void _addMockCourse() {
  //   setState(() {
  //     final index = _courses.length;
  //     _courses = [
  //       ..._courses,
  //       Course(
  //         'Introduction to Flutter ${index + 1}',
  //         'Assem Mohamed',
  //         120 + index * 5,
  //         courseColors[index % courseColors.length],
  //       ),
  //     ];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (_courses.isEmpty) {
      return _buildNoCoursesAvailable();
    } else {
      return _buildCourseListView();
    }
  }

  Widget _buildNoCoursesAvailable() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 400),
      child: SizedBox(
        // width: 1150,
        child: Card(
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 50,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'No Courses Available',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    "You haven't created any courses yet. Start building your first course to make content available for your learners",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withValues(alpha: 0.4),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCourseScreen()));
                  },

                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(
                    'Add New Course',
                    style: TextStyle(
                      fontFamily: "inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Active Courses (${_courses.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              // _addMockCourse,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 3.0,
          ),
          itemBuilder: (context, index) {
            final course = _courses[index];
            return CourseCard(course: course);
          },
        ),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: course.color.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: course.color.withOpacity(0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 8,
              height: double.infinity,
              decoration: BoxDecoration(
                color: course.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Instructor: ${course.instructor}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${course.students}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: course.color,
                  ),
                ),
                const Text(
                  'Students',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCardsRow extends StatelessWidget {
  const FeatureCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    const Color circleBg = Color(0xFFE0F2FF);
    // const Color iconFg = Color(0xFF3B82F6);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: FeatureCard(
            card_color: Colors.purple.shade300,

            iconWidget: const CircleAvatar(
              radius: 28,
              backgroundColor: circleBg,
              child: Image(
                image: AssetImage("assets/icons/create_course_icon.png"),
                width: 20,
                height: 20,
              ),
            ),
            title: 'Create Course',
            description:
                'Build course structure, add lessons and quizzes ',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: FeatureCard(
            card_color: Colors.orange.shade300,
            iconWidget: const CircleAvatar(
              radius: 28,
              backgroundColor: circleBg,
              child: Image(
                image: AssetImage("assets/icons/person icon.png"),
                width: 20,
                height: 20,
              ),
            ),
            title: 'Manage Enrollment',
            description:
                'Control which learners can join and access your courses',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: FeatureCard(
            card_color: Colors.green.shade300,

            iconWidget: const CircleAvatar(
              radius: 28,
              backgroundColor: circleBg,
              child: Image(
                image: AssetImage("assets/icons/performance icon.png"),
                width: 20,
                height: 20,
              ),
            ),
            title: 'Track Progress',
            description: 'Monitor student performance and completion rates',
          ),
        ),
      ],
    );
  }
}

class FeatureCard extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final Color card_color;

  const FeatureCard({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.card_color,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovering = false;
  final Color iconBackgroundColor = const Color(0xFFF1F5F9);
  final Color iconColor = const Color(0xFF3B82F6);
  final Duration animationDuration = const Duration(milliseconds: 200);
  final double scaleOnHover = 1.02;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onHover(true),
      onExit: (event) => _onHover(false),
      child: AnimatedScale(
        duration: animationDuration,
        scale: _isHovering ? scaleOnHover : 1.0,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isHovering ? widget.card_color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovering ? 0.15 : 0.05),
                blurRadius: _isHovering ? 20 : 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.iconWidget,
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isHovering ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize:  14,
                    fontWeight: _isHovering? FontWeight.w700 : FontWeight.w400,
                    color: _isHovering
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.4),
                    height: 1.4,
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
