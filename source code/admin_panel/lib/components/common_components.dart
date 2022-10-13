import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

Widget divider({double? height, Color? color, required BuildContext context}) {
  return Container(
    height: height ?? 0.1,
    color: color ?? Theme.of(context).dividerColor,
  );
}

Widget paidOrFreeSelectionWidget(
    {required bool isPaid,
    required Function(bool) changeHandler,
    required BuildContext context}) {
  return Row(
    children: [
      Text(
        LocalizationString.isPremium,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(
        width: 10,
      ),
      isPaid == true
          ? ThemeIconWidget(
              ThemeIcon.checkMarkWithCircle,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ).ripple(() {
              changeHandler(false);
            })
          : ThemeIconWidget(
              ThemeIcon.outlinedCircle,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ).ripple(() {
              changeHandler(true);
            }),
      const SizedBox(
        width: 50,
      ),
    ],
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