// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../core/cons/Colors/app_colors.dart';
// import '../../core/widgets/app_bar.dart';
//
//
//
// class MyApp2 extends StatelessWidget {
//   const MyApp2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Courses Analytics Dashboard',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         textTheme: GoogleFonts.interTextTheme(),
//       ),
//       home: const DashboardPage(),
//     );
//   }
// }
//
// class DashboardPage extends StatelessWidget {
//   const DashboardPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: Container(
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
//         ),
//
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Courses Analytics Dashboard',
//                 style: GoogleFonts.inter(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 32),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: MetricCard(
//                       title: 'Total Students',
//                       value: '1,200',
//                       change: '+5.2%',
//                       icon: Icons.people_outline,
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                   Expanded(
//                     child: MetricCard(
//                       title: 'Total Courses',
//                       value: '97',
//                       change: '+2.1%',
//                       icon: Icons.menu_book_outlined,
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                   Expanded(
//                     child: MetricCard(
//                       title: 'Completed Courses',
//                       value: '80',
//                       change: '+4.2%',
//                       icon: Icons.check_circle_outline,
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                   Expanded(
//                     child: MetricCard(
//                       title: 'Video Views',
//                       value: '75%',
//                       change: '+5.2%',
//                       icon: Icons.videocam_outlined,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: OnlineNowCard(),
//                   ),
//                   const SizedBox(width: 24),
//
//                   Expanded(
//                     flex: 2,
//                     child: OngoingCoursesCard(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: LoginActivityCard(),
//                   ),
//                   const SizedBox(width: 24),
//                   Expanded(
//                     child: StudentPerformanceCard(),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MetricCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String change;
//   final IconData icon;
//
//   const MetricCard({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.change,
//     required this.icon,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF6B7280),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Icon(icon, color: const Color(0xFF9CA3AF), size: 24),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF111827),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             change,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF10B981),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnlineNowCard extends StatelessWidget {
//   const OnlineNowCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Online Now',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             '500',
//             style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF4ADE80),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Live',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OngoingCoursesCard extends StatelessWidget {
//   const OngoingCoursesCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final courses = [
//       {'name': 'A1/A2 English with HSP', 'progress': 75, 'color': const Color(0xFF1E40AF)},
//       {'name': 'Chemical Nomenclature', 'progress': 65, 'color': const Color(0xFFEC4899)},
//       {'name': 'Celebrating Cultures', 'progress': 30, 'color': const Color(0xFF4ADE80)},
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Ongoing Courses',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               Icon(Icons.more_horiz, color: Colors.grey[400]),
//             ],
//           ),
//           const SizedBox(height: 24),
//           ...courses.map((course) => Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: CourseProgressBar(
//               name: course['name'] as String,
//               progress: course['progress'] as int,
//               color: course['color'] as Color,
//             ),
//           )).toList(),
//         ],
//       ),
//     );
//   }
// }
//
// class CourseProgressBar extends StatelessWidget {
//   final String name;
//   final int progress;
//   final Color color;
//
//   const CourseProgressBar({
//     Key? key,
//     required this.name,
//     required this.progress,
//     required this.color,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF374151),
//               ),
//             ),
//             Text(
//               '$progress/100',
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: LinearProgressIndicator(
//             value: progress / 100,
//             backgroundColor: const Color(0xFFF3F4F6),
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//             minHeight: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class LoginActivityCard extends StatelessWidget {
//   const LoginActivityCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Login Activity',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEFF6FF),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text(
//                   'Last 24h',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF2563EB),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 200,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()} pm',
//                           style: const TextStyle(
//                             color: Color(0xFF9CA3AF),
//                             fontSize: 12,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
//                         if (value.toInt() < months.length) {
//                           return Text(
//                             months[value.toInt()],
//                             style: const TextStyle(
//                               color: Color(0xFF9CA3AF),
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         return const Text('');
//                       },
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 minX: 0,
//                 maxX: 5,
//                 minY: 0,
//                 maxY: 4,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: [
//                       const FlSpot(0, 2),
//                       const FlSpot(1, 1),
//                       const FlSpot(2, 2),
//                       const FlSpot(3, 3),
//                       const FlSpot(4, 2.5),
//                       const FlSpot(5, 3),
//                     ],
//                     isCurved: true,
//                     color: const Color(0xFF6B7280),
//                     barWidth: 2,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 4,
//                           color: Colors.white,
//                           strokeWidth: 2,
//                           strokeColor: const Color(0xFF6B7280),
//                         );
//                       },
//                     ),
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class StudentPerformanceCard extends StatelessWidget {
//   const StudentPerformanceCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Student Performance',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFDBeafe)),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: const [
//                     Text(
//                       'By Year',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF2563EB),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     Icon(
//                       Icons.keyboard_arrow_down,
//                       size: 16,
//                       color: Color(0xFF2563EB),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'Average Grades',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: const [
//               Text(
//                 '85%',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8),
//                 child: Text(
//                   '+3.2% Vs Last Year',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF10B981),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 150,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: 100,
//                 barTouchData: BarTouchData(enabled: false),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         const years = ['2022', '2023', '2024', '2025'];
//                         if (value.toInt() < years.length) {
//                           return Text(
//                             years[value.toInt()],
//                             style: const TextStyle(
//                               color: Color(0xFF9CA3AF),
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         return const Text('');
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 gridData: FlGridData(show: false),
//                 borderData: FlBorderData(show: false),
//                 barGroups: [
//                   BarChartGroupData(
//                     x: 0,
//                     barRods: [
//                       BarChartRodData(
//                         toY: 78,
//                         color: const Color(0xFF2563EB),
//                         width: 40,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(8),
//                           topRight: Radius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 1,
//                     barRods: [
//                       BarChartRodData(
//                         toY: 82,
//                         color: const Color(0xFF2563EB),
//                         width: 40,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(8),
//                           topRight: Radius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 2,
//                     barRods: [
//                       BarChartRodData(
//                         toY: 81,
//                         color: const Color(0xFF2563EB),
//                         width: 40,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(8),
//                           topRight: Radius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                   BarChartGroupData(
//                     x: 3,
//                     barRods: [
//                       BarChartRodData(
//                         toY: 85,
//                         color: const Color(0xFF2563EB),
//                         width: 40,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(8),
//                           topRight: Radius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/widgets/app_bar.dart';





class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  String selectedPeriod = 'Last 24h';
  String performanceFilter = 'By Year';

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
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

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Courses Analytics Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionButton(Icons.refresh, 'Refresh'),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: InteractiveMetricCard(
                      image: Image(
                        image: AssetImage(
                          "assets/icons/hugeicons_students.png",
                        ),
                        height: 24,
                        width: 24,
                      ),
                      title: 'Total Students',
                      value: '1,200',
                      change: '+5.2%',
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade200, Colors.blue],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InteractiveMetricCard(
                      image: Image(
                        image: AssetImage(
                          "assets/icons/total courses icons.png",
                        ),
                        height: 24,
                        width: 24,
                      ),
                      title: 'Total Courses',
                      value: '97',
                      change: '+2.1%',
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade200, Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InteractiveMetricCard(
                      image: Image(
                        image: AssetImage("assets/icons/complete_icon.png"),
                        height: 24,
                        width: 24,
                      ),
                      title: 'Completed Courses',
                      value: '80',
                      change: '+4.2%',
                      gradient: LinearGradient(
                        colors: [Colors.green.shade200, Color(0xFF059669)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InteractiveMetricCard(
                      image: Image(
                        image: AssetImage("assets/icons/mage_video.png"),
                        height: 24,
                        width: 24,
                      ),
                      title: 'Video Views',
                      value: '75%',
                      change: '+5.2%',
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade200, Color(0xFFD97706)],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AnimatedOnlineCard(
                      pulseController: _pulseController,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: InteractiveCoursesCard()),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InteractiveLoginChart(
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: (period) {
                        setState(() => selectedPeriod = period);
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InteractivePerformanceCard(
                      selectedFilter: performanceFilter,
                      onFilterChanged: (filter) {
                        setState(() => performanceFilter = filter);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Refresh Success",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 3),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}

class InteractiveMetricCard extends StatefulWidget {
  final String title;
  final String value;
  final String change;
  final Gradient gradient;
  final Image image;

  const InteractiveMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.gradient,
    required this.image,
  });

  @override
  State<InteractiveMetricCard> createState() => _InteractiveMetricCardState();
}

class _InteractiveMetricCardState extends State<InteractiveMetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: _isHovered ? widget.gradient : null,
            color: _isHovered ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.black.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isHovered
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  widget.image,

                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 16,
                    color: _isHovered ? Colors.white : const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.change,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: _isHovered
                          ? FontWeight.bold.toString()
                          : null,
                      color: _isHovered
                          ? Colors.black
                          : const Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedOnlineCard extends StatelessWidget {
  final AnimationController pulseController;

  const AnimatedOnlineCard({super.key, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Online Now',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '500',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8 + (pulseController.value * 4),
                    height: 8 + (pulseController.value * 4),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF4ADE80,
                      ).withOpacity(1 - pulseController.value * 0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Text(
                'Live',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InteractiveCoursesCard extends StatefulWidget {
  const InteractiveCoursesCard({super.key});

  @override
  State<InteractiveCoursesCard> createState() => _InteractiveCoursesCardState();
}

class _InteractiveCoursesCardState extends State<InteractiveCoursesCard> {
  int? hoveredIndex;

  final courses = [
    {
      'name': 'A1/A2 English with HSP',
      'progress': 75,
      'color': const Color(0xFF1E40AF),
    },
    {
      'name': 'Chemical Nomenclature',
      'progress': 65,
      'color': const Color(0xFFEC4899),
    },
    {
      'name': 'Celebrating Cultures',
      'progress': 30,
      'color': const Color(0xFF4ADE80),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ongoing Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'view', child: Text('View All')),
                  const PopupMenuItem(value: 'add', child: Text('Add Course')),
                  const PopupMenuItem(value: 'manage', child: Text('Manage')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...courses.asMap().entries.map((entry) {
            int index = entry.key;
            var course = entry.value;
            return MouseRegion(
              onEnter: (_) => setState(() => hoveredIndex = index),
              onExit: (_) => setState(() => hoveredIndex = null),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AnimatedCourseProgressBar(
                  name: course['name'] as String,
                  progress: course['progress'] as int,
                  color: course['color'] as Color,
                  isHovered: hoveredIndex == index,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AnimatedCourseProgressBar extends StatelessWidget {
  final String name;
  final int progress;
  final Color color;
  final bool isHovered;

  const AnimatedCourseProgressBar({
    super.key,
    required this.name,
    required this.progress,
    required this.color,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                color: isHovered ? color : const Color(0xFF374151),
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isHovered ? 15 : 14,
                color: isHovered ? color : const Color(0xFF6B7280),
                fontWeight: isHovered ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text('$progress/100'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isHovered ? 14 : 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: isHovered
                ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: isHovered ? 14 : 12,
            ),
          ),
        ),
      ],
    );
  }
}

class InteractiveLoginChart extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const InteractiveLoginChart({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Login Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Row(
                children: [
                  _buildPeriodButton('Last 24h'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('Last Week'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('Last Month'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFF3F4F6),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} pm',
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                        ];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 4,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpots) => Color(0xFF2563EB),

                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} logins',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 2),
                      const FlSpot(1, 1),
                      const FlSpot(2, 2),
                      const FlSpot(3, 3),
                      const FlSpot(4, 2.5),
                      const FlSpot(5, 3),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2563EB),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF2563EB),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2563EB).withOpacity(0.2),
                          const Color(0xFF2563EB).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return InkWell(
      onTap: () => onPeriodChanged(period),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF2563EB),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class InteractivePerformanceCard extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const InteractivePerformanceCard({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Student Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: onFilterChanged,
                initialValue: selectedFilter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDBeafe)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedFilter,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'By Year', child: Text('By Year')),
                  const PopupMenuItem(
                    value: 'By Month',
                    child: Text('By Month'),
                  ),
                  const PopupMenuItem(
                    value: 'By Quarter',
                    child: Text('By Quarter'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Average Grades',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '85%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(width: 12),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '+3.2% Vs Last Year',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (touchedSpots) => Color(0xFF2563EB),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      const years = ['2022', '2023', '2024', '2025'];
                      return BarTooltipItem(
                        '${years[groupIndex]}\n${rod.toY.toInt()}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ['2022', '2023', '2024', '2025'];
                        if (value.toInt() < years.length) {
                          return Text(
                            years[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 78),
                  _buildBarGroup(1, 82),
                  _buildBarGroup(2, 81),
                  _buildBarGroup(3, 85),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: 40,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ],
    );
  }
}
