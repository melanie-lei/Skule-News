import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

Widget errorImage({required double size, required BuildContext context}) {
  return SizedBox(
    height: size,
    width: size,
    child: Center(
        child: ThemeIconWidget(
      ThemeIcon.fav,
      color: Theme.of(context).errorColor,
      size: size / 2,
    )),
  ).borderWithRadius(value: 1, radius: 5,context: context);
}
