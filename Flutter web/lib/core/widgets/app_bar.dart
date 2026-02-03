// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../features/screens/profiles/admin_profile/view.dart';
// import '../../features/screens/profiles/teacher_profile/State_managment/t_profile_cubit.dart';
// import '../../features/screens/profiles/teacher_profile/view.dart';
// import '../../generated/assets.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 100,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         color: const Color(0xffE3F6FF),
//       ),
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             AnimatedCircleAvatar(),
//
//             SizedBox(
//               width: 400,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     onTap: () {},
//                     child: const Text(
//                       "Home",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "inter",
//                         color: Color(0xff0D2772),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   InkWell(
//                     onTap: () {},
//                     child: const Text(
//                       "My Courses",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "inter",
//                         color: Color(0xff0D2772),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   InkWell(
//                     onTap: () {},
//                     child: const Text(
//                       "Dashboard",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "inter",
//                         color: Color(0xff0D2772),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(
//               width: 180,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: SvgPicture.asset(Assets.iconsSearchIcon),
//                     onTap: () {},
//                   ),
//                   const Spacer(),
//                   InkWell(
//                     child: SvgPicture.asset(Assets.iconsBellIcon),
//                     onTap: () {},
//                   ),
//                   const Spacer(),
//                   InkWell(
//                     child: SvgPicture.asset(Assets.iconsMessageIcon),
//                     onTap: () {},
//                   ),
//                   const Spacer(),
//
//                   BlocProvider(
//                     create: (_) => ProfileCubit(),
//                     child: Builder(
//                       builder: (context) {
//                         return InkWell(
//                           child: SvgPicture.asset(Assets.iconsManIcon),
//                           onTap: () {
//                             context.read<ProfileCubit>().getProfileData();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const AdminProfileScreen(),
//                               ));
//
//
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// /// -------------------------
// /// Animated Circle Avatar
// /// -------------------------
// class AnimatedCircleAvatar extends StatefulWidget {
//   const AnimatedCircleAvatar({super.key});
//
//   @override
//   State<AnimatedCircleAvatar> createState() => _AnimatedCircleAvatarState();
// }
//
// class _AnimatedCircleAvatarState extends State<AnimatedCircleAvatar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 2,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: const CircleAvatar(
//                 radius: 20,
//                 backgroundImage: AssetImage(Assets.logo),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/screens/profiles/admin_profile/view.dart';
import '../../generated/assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        color: Color(0xffE3F6FF),
      ) ,
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedCircleAvatar(),

              SizedBox(
                width: 400,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    InkWell(
                        onTap: (){},
                        child: Text("Home",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "inter",
                            color: Color(0xff0D2772)

                        ))),
                    Spacer(),
                    InkWell(
                        onTap: (){},
                        child: Text("My Courses",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "inter",
                            color: Color(0xff0D2772)

                        ))),
                    Spacer(),
                    InkWell(
                        onTap: (){},
                        child: Text("Dashboard",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "inter",
                            color: Color(0xff0D2772)

                        ))),

                  ],
                ),
              ),
              SizedBox(
                width: 180,
                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [


                    InkWell(child: SvgPicture.asset(Assets.iconsSearchIcon),onTap: (){},),
                    Spacer(),
                    InkWell(child: SvgPicture.asset(Assets.iconsBellIcon),onTap: (){},),
                    Spacer(),
                    InkWell(child: SvgPicture.asset(Assets.iconsMessageIcon),onTap: (){},),
                    Spacer(),
                    InkWell(child: SvgPicture.asset(Assets.iconsManIcon),onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminProfileScreen()));
                    },),




                  ],
                ),
              )

            ]
        ),
      ),
    );



  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
class AnimatedCircleAvatar extends StatefulWidget {
  const AnimatedCircleAvatar({super.key});

  @override
  State<AnimatedCircleAvatar> createState() => _AnimatedCircleAvatarState();
}

class _AnimatedCircleAvatarState extends State<AnimatedCircleAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(Assets.logo),
              ),
            ),
          );
        },
      ),
    );
  }
}