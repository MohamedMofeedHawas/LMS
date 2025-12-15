class CourseModel {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String rate;

  CourseModel({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.rate,
  });
}

List<CourseModel> courses = [
  CourseModel(
    imageUrl: "assets/test_images/course_1.png",
    rate: "0%",
    subTitle: "Faculty of Health and Medicine",
    title: "Chemical Nomenclature",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_2.png",
    title: "Class and Conflict in World Cinema",
    subTitle: "Communication and Media",
    rate: "50%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_3.png",
    title: "Psychology in Cinema",
    subTitle: "Faculty of Health and Medicine",
    rate: "40%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_4.png",
    title: "Celebrating Cultures",
    subTitle: "Our Community",
    rate: "25%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_5.png",
    title: "A1/A2 English with H5P",
    subTitle: "English as a Foreign Language",
    rate: "100%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_6.png",
    title: "Dementia care: Caring for the Carers",
    subTitle: "Faculty of Health and Medicine",
    rate: "0%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_1.png",
    rate: "0%",
    subTitle: "Faculty of Health and Medicine",
    title: "Chemical Nomenclature",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_3.png",
    title: "Psychology in Cinema",
    subTitle: "Faculty of Health and Medicine",
    rate: "40%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_6.png",
    title: "Dementia care: Caring for the Carers",
    subTitle: "Faculty of Health and Medicine",
    rate: "0%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_1.png",
    rate: "0%",
    subTitle: "Faculty of Health and Medicine",
    title: "Chemical Nomenclature",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_3.png",
    title: "Psychology in Cinema",
    subTitle: "Faculty of Health and Medicine",
    rate: "40%",
  ),
  CourseModel(
    imageUrl: "assets/test_images/course_2.png",
    title: "Class and Conflict in World Cinema",
    subTitle: "Communication and Media",
    rate: "50%",
  ),
];
