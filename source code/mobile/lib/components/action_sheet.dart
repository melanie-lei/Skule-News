import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class ActionSheet extends StatelessWidget {
  final List<GenericItem> items;
  final Function(GenericItem) itemCallBack;

  const ActionSheet({Key? key, required this.items, required this.itemCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: items.length * 60,
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Row(
              children: <Widget>[
                ThemeIconWidget(items[i].icon!,color: Theme.of(context).iconTheme.color,),
                const SizedBox(width: 20),
                Text(items[i].title, style: Theme.of(context).textTheme.bodyLarge,)
              ],
            ).p16.ripple(() {
              itemCallBack(items[i]);
              Navigator.pop(context);
            })
        ],
      ),
    ).topRounded(10);
  }
}
