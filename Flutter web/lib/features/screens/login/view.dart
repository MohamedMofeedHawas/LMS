import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/features/screens/login/state_management/login_server_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/login/state_management/login_state.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../generated/assets.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPressed = false;
  bool isObscure = true;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: "mohamedabdelstar06@gmail.com");
  final passwordController = TextEditingController(text: "Admin@123");


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Builder(
        builder: (context) {
          final login_Cubit = BlocProvider.of<LoginCubit>(context);
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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              fontFamily: "inter",
                            ),
                          ),
                          SizedBox(width: 5),
                          Image.asset(Assets.iconsHand),
                        ],
                      ),
                      Text(
                        "Enter your details below to access your courses and progress.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "inter",
                          color: Color(0xFF545F70),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),

                        width: 514,
                        height: 310,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "inter",
                                color: Color(0xFF175CD3),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                hintText: "Enter your Email",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "inter",
                                  color: Color(0xFF08303D),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "inter",
                                color: Color(0xFF175CD3),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPressed = !isPressed;
                                      isObscure = !isObscure;
                                    });
                                  },
                                  icon: Icon(
                                    isPressed == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 17,
                                    color: Color(0xFF99A1AF),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                hintText: "Enter your password",

                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "inter",
                                  color: Color(0xFF08303D),
                                ),
                              ),
                            ),
                            SizedBox(height: 9),
                            // InkWell(
                            //   onTap: () {},
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Text(
                            //         "Forget Password?",
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w400,
                            //           fontFamily: "inter",
                            //           color: Color(0xff38BDF8),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 30),

                            BlocBuilder<LoginCubit, LoginState>(
                              bloc: login_Cubit,
                              builder: (context, state) {
                                final isLoading = state is LoadingLoginState;

                                return


                                      InkWell(
                                        onTap: isLoading ? null : () {
                                          SystemSound.play(
                                            SystemSoundType.click,
                                          );
                                          context
                                              .read<LoginCubit>()
                                              .postLoginData(
                                            usernameController,
                                            passwordController,
                                            context,
                                          );
                                        },
                                        child: Center(
                                          child:
                                          Container(
                                            width: 470,
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: isLoading
                                                  ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Logging in...",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "inter",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  : Text(
                                                "Login",
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
                                      );



                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

