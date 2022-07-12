import 'package:flutter/material.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  const OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = const [
  OnboardingContents(
    title: "Onboarding screen title 1",
    image: "assets/images/onboarding1.png",
    desc: "Lorem ipsum dolor sit amet. Sed corporis quaerat qui veritatis ipsum aut obcaecati culpa a adipisci mollitia.",
  ),
  OnboardingContents(
    title: "Onboarding screen title 2",
    image: "assets/images/onboarding2.png",
    desc: "Lorem ipsum dolor sit amet. Sed corporis quaerat qui veritatis ipsum aut obcaecati culpa a adipisci mollitia.",
  ),
  OnboardingContents(
    title: "Onboarding screen title 3",
    image: "assets/images/onboarding3.png",
    desc:
    "Lorem ipsum dolor sit amet. Sed corporis quaerat qui veritatis ipsum aut obcaecati culpa a adipisci mollitia.",
  ),
];