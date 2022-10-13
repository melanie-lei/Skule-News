import 'package:skule_news_mobile/helper/common_import.dart';

class OnBoardingContents {
  final String title;
  final String image;
  final String desc;

  const OnBoardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnBoardingContents> contents =  [
  OnBoardingContents(
    title: LocalizationString.onBoardingTitle1,
    image: "assets/images/onboarding1.png",
    desc: LocalizationString.onBoardingDescription1,
  ),
  OnBoardingContents(
    title: LocalizationString.onBoardingTitle2,
    image: "assets/images/onboarding2.png",
    desc: LocalizationString.onBoardingDescription2,
  ),
  OnBoardingContents(
    title: LocalizationString.onBoardingTitle3,
    image: "assets/images/onboarding3.png",
    desc: LocalizationString.onBoardingDescription3,
  ),
];