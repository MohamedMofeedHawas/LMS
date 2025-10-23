import 'package:flutter/material.dart';
import '../cons/Colors/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo with enhanced styling
              TweenAnimationBuilder<double>(
                duration: Duration(seconds: 3),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * (0.5 - (value - 0.5).abs())),
                    child: Transform.rotate(
                      angle: 0.02 * (0.5 - (value - 0.5).abs()),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xFFF0F0F0)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF175CD3).withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 1,
                              spreadRadius: 0,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF175CD3), Color(0xFF53B1FD), Color(0xFF175CD3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                gradient: LinearGradient(
                                  colors: [Color(0xFF175CD3), Color(0xFF53B1FD)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                Icons.rocket_launch,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              
              // App Title
              Text(
                "SKY Learn",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: "inter",
                  color: Color(0xFF175CD3),
                ),
              ),
              SizedBox(height: 10),
              
              // Subtitle
              Text(
                "Loading your learning experience...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "inter",
                  color: Color(0xFF545F70),
                ),
              ),
              SizedBox(height: 40),
              
              // Enhanced Circular Progress Indicator
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    // Outer ring
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF53B1FD)),
                      strokeWidth: 4,
                    ),
                    // Inner ring
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF175CD3)),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              
              // Feature icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeatureIcon(Icons.star, 0),
                  SizedBox(width: 20),
                  _buildFeatureIcon(Icons.check_circle, 0.5),
                  SizedBox(width: 20),
                  _buildFeatureIcon(Icons.trending_up, 1.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, double delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final animationValue = (value + delay) % 1.0;
        final scale = 0.7 + 0.3 * (0.5 - (animationValue - 0.5).abs()) * 2;
        final opacity = 0.7 + 0.3 * (0.5 - (animationValue - 0.5).abs()) * 2;
        
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF175CD3), Color(0xFF53B1FD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF175CD3).withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
