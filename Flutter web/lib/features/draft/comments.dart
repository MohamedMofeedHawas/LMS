// code logout

// IconButton(
// icon: Icon(Icons.logout),
// onPressed: () async {
// await LogoutServer.logout();
// },
// )



// String? email;
//
// @override
// void initState() {
//   super.initState();
//   loadEmail();
// }
//
// void loadEmail() async {
//   email = await SharedPrefHelper.getEmail();
//   setState(() {});
// }

// Text(email.toString()),


//
/*
IconButton(onPressed: (){

                              showDialog(
                                context: navigatorKey.currentContext!,
                                barrierDismissible: false,
                                builder: (_) => Dialog(
                                  // backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    width: 420,
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(Assets.deleteIcon, width: 60, height: 60,color: Colors.red.withValues(alpha: 0.6),),
                                        // Icon(Icons.logout, color: Colors.red.withValues(alpha: 0.6), size: 60),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Confirm Deletion",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Are you sure you want to Delete This Course?",
                                          style: TextStyle(color: Colors.white70, fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 18),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.blueGrey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();

                                              },
                                              child: const Text("No"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.redAccent,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: ()  {
                                                final int currentIndex = widget.index;
                                                Navigator.of(context).pop();
                                                widget.onDelete(currentIndex);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      children: [
                                                        const Icon(Icons.check_circle, color: Colors.white),
                                                        const SizedBox(width: 10),
                                                        const Expanded(
                                                          child: Text(
                                                            'Course deleted successfully!',
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: Colors.green.shade600,
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                    duration: const Duration(seconds: 3),
                                                    elevation: 6,
                                                  ),
                                                );
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                            }, icon: SvgPicture.asset(Assets.deleteIcon),),
 */