import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

Widget divider({double? height, Color? color, required BuildContext context}) {
  return Container(
    height: height ?? 0.1,
    color: color ?? Theme.of(context).dividerColor,
  );
}

Widget noDataFound(BuildContext context){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ThemeIconWidget(
          ThemeIcon.noData,
          size: 80,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          LocalizationString.noDataFound,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(
              color: Theme.of(context).primaryColor,fontWeight: FontWeight.w900),
        )
      ],
    ),
  );
}