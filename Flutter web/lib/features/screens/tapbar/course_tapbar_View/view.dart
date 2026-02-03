import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class CourseTapbarScreen extends StatelessWidget {
  const CourseTapbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Color(
  0xfff6fbff
),
      body: ListView(
        padding: EdgeInsetsGeometry.directional(top: 10,start: 10,end: 10),
        children: const [
          CultureVideoContainer(),
          CustomCardScreen()
        ],
      ),
    );
  }
}

class CultureVideoContainer extends StatefulWidget {
  const CultureVideoContainer({super.key});

  @override
  State<CultureVideoContainer> createState() => _CultureVideoContainerState();
}

class _CultureVideoContainerState extends State<CultureVideoContainer> {
  late VideoPlayerController controller;
  bool isCollabsed = false;
  bool showPlayButton = true; // متغير يتحكم في ظهور الزرار


  @override
  void initState() {
    super.initState();

    // رابط فيديو صالح للـ Web
    controller = VideoPlayerController.network(
      "Videos/test.mp4",
    )
      ..initialize().then((_) {
        // بمجرد ما الفيديو يجهز، نحدث الواجهة
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final height = width * 0.51;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),topLeft: Radius.circular(12),topRight: Radius.circular(12)),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان و Collapse toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  isCollabsed
                      ? const Icon(Icons.arrow_upward, color: Colors.blue)
                      : const Icon(Icons.arrow_downward, color: Colors.blue),
                  const SizedBox(width: 20),
                  const Text(
                    "Welcome! Aloha! Bonvenon!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  isCollabsed = !isCollabsed;
                  setState(() {});
                },
                child: const Text(
                  "Collapse all",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "inter",
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
if (!isCollabsed)...[
          const SizedBox(height: 16),
          const Text(
            "We are all from different communities but we are all one community at Mount Orange. "
                "This course is for students, teachers and the wider community members to share and learn about our cultural diversity.",
            style: TextStyle(fontSize: 15, height: 1.4, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          Center(
            child: Container(
              width: 800,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: controller.value.isInitialized
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    // زرار play/pause
                    Positioned(
                      top: 170,
                      left: 355,
                      child: GestureDetector(
                        onTap: () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 45,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          const SizedBox(height: 20),

          // Card أسفل الفيديو
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ListTile(
                isThreeLine: true,
                leading: const Icon(
                  Icons.folder_delete_outlined,
                  color: Colors.black87,
                  size: 28,
                ),
                title: const Text(
                  "Interesting cities",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: const Text(
                  "No need to download these images - view them directly in the browser!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )]
        ],
      ),
    );
  }
}


class CustomCardScreen extends StatelessWidget {
  const CustomCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Container(
        width: 1312,
        height: 1171,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Activities",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Image.asset(
                  'assets/icons/database_icon.png',
                  width: 20,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Database: Food for Moodlers",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Text(
                        "Share your favourite meal or recipe with others here.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Image.asset("assets/images/food.png",width: 128,height: 100,),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32, thickness: 1, color: Colors.grey),


            Row(
              children: [
                SvgPicture.asset("assets/icons/glossary_icon.png", width: 20,
                  height: 24,
                  fit: BoxFit.cover,),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Glossary: International Teaching Terms",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Text(
                        "Educators around the world use admin_profile variety of phrases and acronyms. Add yours to this glossary.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: const [
            //     Text(
            //       "Glossary: International Teaching Terms",
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.blueAccent,
            //       ),
            //     ),
            //     Text(
            //       "Educators around the world use a variety of phrases and acronyms. Add yours to this glossary.",
            //       style: TextStyle(fontSize: 14, color: Colors.grey),
            //     ),
            //   ],
            // ),

            const Divider(height: 32, thickness: 1, color: Colors.grey),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Assignment: Languages of Love",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  "Speak to us!",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      );

  }
}

