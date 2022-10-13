import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class PackageTile extends StatelessWidget {
  final PackageModel package;
  final VoidCallback deleteCallback;

  const PackageTile(
      {Key? key, required this.package, required this.deleteCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor.darken(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(package.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
              Text('\$${package.price}',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          Container(
            height: 40,
            width: 40,
            color: Theme.of(context).primaryColor,
            child: const ThemeIconWidget(
              ThemeIcon.delete,
              color: Colors.white,
            ),
          ).round(8).ripple(() {
            deleteCallback();
          })
        ],
      ).p16,
    ).round(8);
  }
}
