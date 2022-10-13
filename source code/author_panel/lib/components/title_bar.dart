import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class TitleBar extends StatelessWidget {
  final String title;

  const TitleBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    ).round(15).shadow(shadowOpacity: 0.1,context: context);
  }
}
