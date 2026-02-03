import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/cons/context/navigation_key.dart';
import 'package:lms/features/draft/test.dart';
import 'package:lms/features/screens/ActivateAccountScreen/view.dart';
import 'package:lms/features/screens/Announcement/view.dart';
import 'package:lms/features/screens/courses/admin/view.dart';
import 'package:lms/features/screens/courses/teacher/view.dart';
import 'package:lms/features/screens/hero_section/view.dart';
import 'package:lms/features/screens/login/view.dart';
import 'package:lms/features/screens/pre_loading/loading_screen.dart';
import 'package:lms/core/services/app_initialization_service.dart';
import 'package:lms/features/screens/profiles/admin_profile/view.dart';

import 'features/draft/test_screen.dart';
import 'features/screens/Courses_dashboard/view.dart';
import 'features/screens/Create_user/View.dart';
import 'features/screens/Verify_email/view.dart';
import 'features/screens/add_course/Adding_view.dart';
import 'features/screens/add_course/view.dart';
import 'features/screens/celeberating cultures/view.dart';
import 'features/screens/chat_bot/view.dart';
import 'features/screens/courses/student/view.dart';
import 'features/screens/get_users/state_managment/get_users_cubit.dart';
import 'features/screens/get_users/view.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode && kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.toString().contains('toJsonMap') &&
          !details.toString().contains('_nodeToJson')) {
        FlutterError.presentError(details);
      }
    };
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(milliseconds: 100));
    
    await AppInitializationService.initializeApp();
    
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),

        navigatorKey: navigatorKey,
        title: "SKY Learn",
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'inter',
          scaffoldBackgroundColor: Color(0xFFE0F2FE),
        ),
        debugShowCheckedModeBanner: false,
        home:
        // CelebratingScreen()
        // CoursesManagementApp()
        // LearnMateChat()
        // LearnMateApp()
        // DashboardPage()
        // ProfileScreen()
        // StudentProfileScreen()
        // CoursesManagementApp()
        // LearnMateChat()
        // AdminCourseScreen()
        // AnnouncementScreen()
        // AttendanceChart()
        // AdminCourseScreen()
        // TeacherCourseScreen()
        // StudentCourseScreen()
        // HeroSectionScreen()
        // UploadCoursePage()
        // CreateUserScreen()
        // ActivateAccountScreen()
        // AdminProfileScreen()
        // CreateDepartmentScreen()
        // AddCourseScreen()
// SignUpScreen()
        _isInitialized ? VerifyScreen() : LoadingScreen(),
//           GetUsersScreen()
      ),
    );
  }
}

