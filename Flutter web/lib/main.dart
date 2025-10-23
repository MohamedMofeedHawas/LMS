import 'package:flutter/material.dart';
import 'package:lms/core/cons/context/navigation_key.dart';
import 'package:lms/features/screens/login/view.dart';
import 'package:lms/core/widgets/loading_screen.dart';
import 'package:lms/core/services/app_initialization_service.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    // Start initialization immediately but don't wait for it
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show loading screen immediately, then initialize
    await Future.delayed(Duration(milliseconds: 100)); // Small delay to show loading screen
    
    // Initialize app services
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
          // Prevent white flash by setting scaffold background
          scaffoldBackgroundColor: Color(0xFFE0F2FE),
        ),
        debugShowCheckedModeBanner: false,
        home: _isInitialized ? LoginScreen() : LoadingScreen(),
      ),
    );
  }
}

