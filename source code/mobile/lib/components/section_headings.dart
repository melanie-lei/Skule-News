import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

Widget headingType1(
    {required String title,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headline2).bP4,
      Container(
        width: 100,
        height: 2,
        color: Theme.of(context).errorColor,
      ).bP8,
      seeAllPress != null
          ? Text(LocalizationString.seeAll,
                  style: Theme.of(context).textTheme.bodySmall)
              .ripple(() {
              seeAllPress();
            })
          : Container()
    ],
  );
}

Widget headingType2(
    {required String title,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title, style: Theme.of(context).textTheme.headline2),
      const Spacer(),
      seeAllPress != null
          ? Text(LocalizationString.seeAll,
                  style: Theme.of(context).textTheme.bodySmall)
              .ripple(() {
              seeAllPress();
            })
          : Container()
    ],
  );
}

Widget headingType3(
    {required String title,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(height: 20, width: 2, color: Theme.of(context).dividerColor)
          .rP8,
      Text(title, style: Theme.of(context).textTheme.bodyMedium),
      const Spacer(),
      seeAllPress != null
          ? Text(LocalizationString.seeAll,
                  style: Theme.of(context).textTheme.bodySmall)
              .ripple(() {
              seeAllPress();
            })
          : Container()
    ],
  );
}

Widget headingType5(
    {required String title,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const Spacer(),
      seeAllPress != null
          ? Text(LocalizationString.seeAll,
                  style: Theme.of(context).textTheme.bodyLarge)
              .ripple(() {
              seeAllPress();
            })
          : Container()
    ],
  );
}

Widget headingType4(
    {required String title,
    required String subTitle,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleSmall),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.center,
      ).setPadding(left: 25, right: 25, bottom: 25, top: 8)
    ],
  );
}

Widget headingType7(
    {required String title,
    required String subTitle,
    VoidCallback? seeAllPress,
    required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ).setPadding(top: 5)
        ],
      ),
      seeAllPress != null
          ? Text(LocalizationString.seeAll,
                  style: Theme.of(context).textTheme.bodySmall)
              .ripple(() {
              seeAllPress();
            })
          : Container()
    ],
  );
}

Widget headingType6(
    {required String title,
    required String subTitle,
    VoidCallback? searchPress,
    required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          searchPress != null
              ? Text(
                  LocalizationString.search,
                  style: Theme.of(context).textTheme.bodySmall,
                ).ripple(() {
                  searchPress();
                })
              : Container()
        ],
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.center,
      ).setPadding(right: 25, bottom: 10, top: 4)
    ],
  );
}
