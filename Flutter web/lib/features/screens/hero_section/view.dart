import 'package:flutter/material.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../core/widgets/app_bar.dart';

class HeroSectionScreen extends StatelessWidget {
  const HeroSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(width: double.infinity,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Text("Learn Smarter,Grow Faster.",style: TextStyle(

                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  fontFamily: "inter",
                  color: Color(0xff175CD3)

                ),),
                Text("Your All-in-One Learning ",style: TextStyle(

                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    fontFamily: "inter",
                    color: Color(0xff175CD3)

                ),),
                Text("Experience.",style: TextStyle(

                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    fontFamily: "inter",
                    color: Color(0xff175CD3)

                ),),
                Text("Access interactive courses, track your progress, and achieve your ",style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                    color: Color(0xff46556C)

                ),),
                Text("goals — all in one intuitive learning platform designed to empower ",style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                    color: Color(0xff46556C)

                ),),
                Text("students and educators.",style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                    color: Color(0xff46556C)

                ),),
                SizedBox(height: 35,),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                    onTap: (){},

                    child: Center(
                      child: Container(
            width: 185,
            height: 45,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1849A9),
                  Color(0xFF53B1FD),
                ],
              ),

              color: Color(0xFF175CD3),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Start Learning",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "inter",
                  color: Colors.white,
                ),
              ),
            ),
                      ),
                    ),
                      ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: (){},

                      child: Center(
                        child: Container(
                          width: 185,
                          height: 45,

                          decoration: BoxDecoration(

                  border: Border.all(
                    color: Color(0xff2E90FA),
                    width: 1
                  ),
                            color: Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Explore Courses",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "inter",
                                color: Color(0xff2E90FA),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),

            Stack(
              children: [
                Image.asset("assets/images/man-welcom.png",width: 732,height: 600,),
                Positioned(top: 290,
                    left: 25,
                    child: Image.asset("assets/images/frame_1.png")),
                Positioned(top: 200,
                    right: 100,
                    child: Image.asset("assets/images/frame_2.png")),

              ],
            )
          ]
        ),
      ),
    );
  }
}
