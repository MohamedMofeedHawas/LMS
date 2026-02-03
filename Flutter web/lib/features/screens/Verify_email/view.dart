import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/features/screens/Verify_email/state_management/verify_server_cubit.dart';
import 'package:lms/features/screens/Verify_email/state_management/verify_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/login/state_management/login_state.dart';

import '../../../core/cons/Colors/app_colors.dart';
import '../../../generated/assets.dart';


class VerifyScreen  extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VerifyScreen> {

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: "mohamedabdelstar06@gmail.com");


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyCubit(),
      child: Builder(
        builder: (context) {
          final verify_Cubit = BlocProvider.of<VerifyCubit>(context);
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
                        "Enter your email address to check your account and continue.",
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
                        height: 223,
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
                            SizedBox(height: 12),
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
                            SizedBox(height: 25),

                            SizedBox(height: 9),

                            BlocBuilder<VerifyCubit, VerifyState>(
                              bloc: verify_Cubit,
                              builder: (context, state) {
                                final isLoading = state is LoadingVerifyState;

                                return


                                      InkWell(
                                        onTap: isLoading ? null : () {
                                          SystemSound.play(
                                            SystemSoundType.click,
                                          );
                                          context
                                              .read<VerifyCubit>()
                                              .postVerifyData(
                                            usernameController,
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
                                                    "Verifying Email...",
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
                                                "Continue",
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
                                    // const SizedBox(width: 16),




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

