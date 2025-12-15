import 'package:flutter/material.dart';

import '../../../core/widgets/app_bar.dart';
import '../tapbar/activites/view.dart';
import '../tapbar/course_tapbar_View/view.dart';
import '../tapbar/grades/view.dart';
import '../tapbar/participants/view.dart';



class CelebratingScreen extends StatelessWidget {
  const CelebratingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
        ),

        child: ListView(
          padding: const EdgeInsetsDirectional.only(start: 70, top: 15,end: 70),
          children: [
            const SizedBox(height: 20),

            const Text(
              "Celebrating Cultures",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            DefaultTabController(
              length: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Course"),
                      Tab(text: "Participants"),
                      Tab(text: "Grades"),
                      Tab(text: "Activities"),
                    ],
                  ),

                  SizedBox(
                    height: 500,
                    child: const TabBarView(
                      children: [
                        CourseTapbarScreen(),
                        ParticipantsTapbarScreen(),
                        GradesTapbarScreen(),
                        ActivitesTapbarScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
